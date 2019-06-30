`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:26:48 05/15/2019 
// Design Name: 
// Module Name:    ID_STAGE 
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
module instruction_decode(pc4,inst,
              wdi,clk,clrn,bpc,jpc,pcsource,
				  m2reg,wmem,aluc,aluimm,a,b,imm,
				  shift,rsrtequ,id_wreg,wb_wreg,id_rn,wb_rn,id_wz
    );
	 input [31:0] pc4,inst,wdi;		//pc4-PCֵ���ڼ���jpc��inst-��ȡ��ָ�wdi-��Ĵ���д�������
	 input clk,clrn;		//clk-ʱ���źţ�clrn-��λ�źţ�
	 input rsrtequ;		//branch�����ź� Z��־λ
	 input wb_wreg;		//WB�����ص�д���ź�
	 input [4:0] wb_rn;		//WB�����ص�Ŀ�ļĴ�����
	 
	 output [31:0] bpc,jpc,a,b,imm;		//bpc-branch_pc��jpc-jump_pc��a-�Ĵ���������a��b-�Ĵ���������b��imm-������������
	 output [2:0] aluc;		//ALU�����ź�
	 output [1:0] pcsource;		//��һ��ָ���ַѡ��BTAKEN
	 output [4:0] id_rn;    //Ŀ�ļĴ���d
	 output m2reg,wmem,aluimm,shift,id_wreg; //��SLD,WMEM,ALUIMM,SHIFT,WREG���ֿ����ź�	
	 output id_wz;   //WZ
	 
	 wire [5:0] op,func;
	 wire [4:0] rs,rt,rd;
	 wire [31:0] qa,qb,br_offset;
	 wire [15:0] ext16;
	 wire regrt,sext,e;
	 
	 assign func=inst[25:20];  
	 assign op=inst[31:26];
	 assign rs=inst[9:5];
	 assign rt=inst[4:0];
	 assign rd=inst[14:10];
	 
	 Control_Unit cu(rsrtequ,func,		//������
	             op,id_wreg,m2reg,wmem,aluc,regrt,aluimm,
					 sext,pcsource,shift,id_wz);
			 
	 Regfile rf (rs,rt,wdi,wb_rn,wb_wreg,clk,clrn,qa,qb);		//�Ĵ����ѣ���32��32λ�ļĴ�����0�żĴ�����Ϊ0���������ؽ�����д��Ĵ���
	 mux5_2_1 des_reg_num (rd,rt,regrt,id_rn); //		ѡ��Ŀ�ļĴ�����������rd,����rt��ȡ���ǼĴ�������ָ�����Loadָ�

	 assign a=qa;
	 assign b=qb;

	 assign e=sext&inst[25];//������չ��0��չ
	 assign ext16={16{e}};//������չ
	 assign imm={ext16,inst[25:10]};		//�����������з�����չ

	 assign br_offset={imm[29:0],2'b00};		//����ƫ�Ƶ�ַ
	 add32 br_addr (pc4,br_offset,bpc);		//beq,bneָ���Ŀ���ַ�ļ���
	 assign jpc={pc4[31:28],inst[25:0],2'b00};		//jumpָ���Ŀ���ַ�ļ���
	 
endmodule