`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:33:59 05/14/2019 
// Design Name: 
// Module Name:    PPCPU 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module PPCPU(Clock, Resetn, PC, IF_Inst, ID_Inst, EXE_Alu, MEM_Alu, WB_Alu
    );
	 input Clock, Resetn;  //ʱ�Ӻ������ź�
	 output [31:0] PC, IF_Inst, ID_Inst;   //���PC��������ȡָ��׶ε�ָ�����׶ε�ָ��
	 output [31:0] EXE_Alu, MEM_Alu, WB_Alu;   //���ִ�м���ALU��������MEM�����д�ؽ��
	 
	 wire [31:0] npc;  //�����pc����һ��pc
	 wire [1:0] pcsource; //pc��ѡ������ź�
	 wire [31:0] bpc, jpc, if_pc4, id_pc4; //��֧��תָ�����תָ���label
	 
	 wire [31:0] wdi; //wdi-��Ĵ���д�������
	 wire id_m2reg, exe_m2reg, mem_m2reg, wb_m2reg;
	 wire id_wmem, exe_wmem, mem_wmem;
	 wire [2:0] id_aluc, exe_aluc;
	 wire id_aluimm, exe_aluimm;
	 wire [31:0] id_a, exe_a;
	 wire [31:0] id_b, exe_b, mem_b;
	 wire [31:0] id_imm, exe_imm;
	 wire id_shift, exe_shift;
	 wire exe_z, mem_z;	 
 	 wire id_wz, exe_wz;
	 wire id_wreg, exe_wreg, mem_wreg, wb_wreg;
	 wire [4:0] id_rn, exe_rn, mem_rn, wb_rn;
	 wire [31:0] mem_mo, wb_mo;


	 program_counter PCR (~Clock, Resetn, npc, PC);   //ʵ��PC��PC����ʱ�Ӻ������źţ�������һ��PC��������PC�� PC=npc
	 
	 instruction_fetch IF_STAGE (pcsource, PC, bpc, jpc, if_pc4, npc, IF_Inst);  //IF�� pc4���������ID��������ת��ַ��npc-����ѡ�����һ��ָ���ַ��inst-����pcȡ����ָ��
	 
	 instruction_register IR(if_pc4, IF_Inst, ~Clock, Resetn, id_pc4, ID_Inst);  //��ˮ�߼Ĵ���IR��ԭ�����
	 
	 instruction_decode ID_STAGE (id_pc4, ID_Inst, wdi, Clock, Resetn, bpc, jpc, pcsource, 
											id_m2reg, id_wmem, id_aluc, id_aluimm, id_a, id_b, id_imm,
											id_shift, mem_z , id_wreg, wb_wreg, id_rn, wb_rn, id_wz);   //���뼶
		 
	 id_exe_register ID_EXE (.clk(~Clock), .clrn(Resetn),   
									 .id_wreg(id_wreg), .id_m2reg(id_m2reg), .id_wmem(id_wmem), .id_aluc(id_aluc), .id_aluimm(id_aluimm), 
									 .id_a(id_a), .id_b(id_b), .id_imm(id_imm), .id_rn(id_rn), .id_shift(id_shift), .id_wz(id_wz),
									 .exe_wreg(exe_wreg), .exe_m2reg(exe_m2reg), .exe_wmem(exe_wmem), .exe_aluc(exe_aluc), .exe_aluimm(exe_aluimm),
									 .exe_a(exe_a), .exe_b(exe_b), .exe_imm(exe_imm), .exe_rn(exe_rn), .exe_shift(exe_shift), .exe_wz(exe_wz));  //��ˮ�߼Ĵ���
									 
	 execute EXE_STAGE (exe_aluc, exe_aluimm, exe_a, exe_b, exe_imm, exe_shift, EXE_Alu, exe_z);//���ݿ����źŽ�������
	 
	 exe_mem_register_withWZ EXE_MEM (.clk(~Clock),.clrn(Resetn), 
												 .mem_in_z(mem_z),.exe_in_z(exe_z),.exe_wz(exe_wz), 
												 .exe_wreg(exe_wreg),.exe_m2reg(exe_m2reg),.exe_wmem(exe_wmem),.exe_alu(EXE_Alu),.exe_b(exe_b),.exe_rn(exe_rn), 
												 .mem_wreg(mem_wreg),.mem_m2reg(mem_m2reg),.mem_wmem(mem_wmem),.mem_alu(MEM_Alu),.mem_b(mem_b),.mem_rn(mem_rn),.mem_out_z(mem_z));
	 
	 memory MEM_STAGE (mem_wmem, MEM_Alu, mem_b, Clock, mem_mo);  //�洢����
	 
	 mem_wb_register MEM_WB (mem_wreg, mem_m2reg, mem_mo, MEM_Alu, mem_rn, ~Clock, Resetn,
									 wb_wreg, wb_m2reg, wb_mo, WB_Alu, wb_rn);  //MEM/WB��ˮ�߼Ĵ���
	 
	 write_back WB_STAGE (WB_Alu, wb_mo, wb_m2reg, wdi);   //д�ؼ�

endmodule
