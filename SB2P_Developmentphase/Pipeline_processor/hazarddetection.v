module HazardDetection(
     JRSignalin,
     BranchSignalin,
	  Hit,
    
    
     NopSel
);

// Default assignments
// NopSel logic
input JRSignalin,BranchSignalin,Hit;
output  NopSel;

assign NopSel = (BranchSignalin & !Hit) | JRSignalin;
endmodule

