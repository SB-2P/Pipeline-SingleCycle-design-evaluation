module Jump_unit(
    // fetch inputs
    instruction, PC1, PC,

    // execute inputs
    JRSignal,
    BranchSignal,
    Hit,

    // outputs
    S0, S1, IF_flush, JumpToAddress, prediction
);

    input [31:0] instruction, PC, PC1;
    input JRSignal, BranchSignal, Hit;
    
    output reg [31:0] JumpToAddress;
    output S0, S1, IF_flush;
    output reg prediction;
    
    parameter Jump = 6'h2, JAL = 6'h3; // JAL opcode = 3
    parameter BEQ = 6'h4;              // BEQ opcode
    parameter BNE = 6'h5;              // BNE opcode
    
    wire [31:0] jump_address;
    wire [5:0] opcode;
    wire [15:0] branch_offset;
    wire [25:0] label;
    wire [31:0] branch_offset_extended;
    wire [31:0] branch_address;
    wire is_backward, is_JumpIns, is_BranchIns, is_nextBorJ;
    
    assign opcode = instruction[31:26];
    assign label = instruction[25:0];
    assign branch_offset = instruction[15:0];
    
    // calculating TargetAddress for jump and branch instructions
    assign jump_address = {6'b0, label};
    
    Sign_Extend SEb(.in(branch_offset), .out(branch_offset_extended));
    adder32bit addbranchpc(.IN1(branch_offset_extended), .IN2(PC1), .OUT(branch_address));
    
    // We want to predict Taken if we are branching backwards, Not Taken Otherwise...
    assign is_backward = branch_address < PC1;
    
    assign is_JumpIns = ((opcode == Jump) | (opcode == JAL));
    assign is_BranchIns = ((opcode == BEQ) | (opcode == BNE));
    assign is_nextBorJ = (is_JumpIns | is_BranchIns);
    
    // Only Set Prediction as 1 if we are branching backwards (predict taken), and Set to 0 if we are branching Forwards (NotTaken),
    // We also need it to be 0 for any other instruction because else will ruin the HIT Signal design.
    always @(*) begin
        prediction = 1'b0;
        JumpToAddress = 32'b0; // Default value to avoid latch inference
        
        if (is_JumpIns) begin
            JumpToAddress = jump_address;
        end
        
        if (is_BranchIns) begin
            if (is_backward) begin
                JumpToAddress = branch_address;
                prediction = 1'b1;
            end
				else begin
					JumpToAddress = PC1;
				end
        end
    end
    
    assign S1 = JRSignal | (~Hit & BranchSignal);
    assign S0 = (~JRSignal & is_nextBorJ) | (~Hit & BranchSignal);
    assign IF_flush = JRSignal | (~Hit & BranchSignal);

endmodule


