From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Quantum Atlas10k3 firmware / scsi problems
Date: Mon, 20 Jan 2003 21:01:07 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0301202056380.3184-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from localhost (swmike@localhost)
	by uplift.swm.pp.se (8.11.6/8.9.3) with ESMTP id h0KK17631734
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jan 2003 21:01:07 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I thought I solved my scsi problems by upgrading my quantum atlas10k3 
firmware:

Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: QUANTUM  Model: ATLAS10K3_36_SCA Rev: 020W
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 02 Lun: 00
  Vendor: QUANTUM  Model: ATLAS10K3_36_SCA Rev: 020W
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 03 Lun: 00
  Vendor: QUANTUM  Model: ATLAS10K3_73_SCA Rev: 020W
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 04 Lun: 00
  Vendor: QUANTUM  Model: ATLAS10K3_73_SCA Rev: 020W
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 05 Lun: 00
  Vendor: QUANTUM  Model: ATLAS10K3_73_SCA Rev: 020W
  Type:   Direct-Access                    ANSI SCSI revision: 03

This has worked perfectly for 3 weeks (much longer since my last problem) 
but the errors showed up again this afternoon. Log supplied below. Anyone 
have any other ideas? The 020W firmware is from Quantum and it seems to be 
created this summer. Anyone can decode exactly what is happning below? 
After all this the system continues running just like normal. Any help 
appreciated. Kernel is latest redhat 7.3 kernel 2.4.18-19.7.xsmp, adaptec 
7899 controller.

Jan 20 15:19:41 uplift kernel: <<4>Recovery code awake
Jan 20 15:19:42 uplift kernel: aic7xxx_abort returns 0x2002
Jan 20 15:19:42 uplift kernel: scsi0:0:3:0: Attempting to queue an ABORT 
message
Jan 20 15:19:42 uplift kernel: scsi0: Dumping Card State while idle, at 
SEQADDR 0x8
Jan 20 15:19:42 uplift kernel: ACCUM = 0x0, SINDEX = 0xec, DINDEX = 0xe4, 
ARG_2 = 0x0
Jan 20 15:19:42 uplift kernel: HCNT = 0x0 SCBPTR = 0x9
Jan 20 15:19:42 uplift kernel: SCSISEQ = 0x12, SBLKCTL = 0xa
Jan 20 15:19:42 uplift kernel:  DFCNTRL = 0x0, DFSTATUS = 0x89
Jan 20 15:19:42 uplift kernel: LASTPHASE = 0x1, SCSISIGI = 0x0, SXFRCTL0 = 
0x80
Jan 20 15:19:42 uplift kernel: SSTAT0 = 0x0, SSTAT1 = 0x8
Jan 20 15:19:42 uplift kernel: SCSIPHASE = 0x0
Jan 20 15:19:42 uplift kernel: STACK == 0x3, 0x108, 0x160, 0xe7
Jan 20 15:19:42 uplift kernel: SCB count = 254
Jan 20 15:19:42 uplift kernel: Kernel NEXTQSCB = 160
Jan 20 15:19:42 uplift kernel: Card NEXTQSCB = 160
Jan 20 15:19:42 uplift kernel: QINFIFO entries: 
Jan 20 15:19:42 uplift kernel: Waiting Queue entries: 
Jan 20 15:19:42 uplift kernel: Disconnected Queue entries: 26:106 
Jan 20 15:19:42 uplift kernel: QOUTFIFO entries: 
Jan 20 15:19:42 uplift kernel: Sequencer Free SCB List: 9 8 31 25 17 15 14 
27 16 7 4 11 12 23 22 5 2
8 30 29 3 18 0 20 10 21 13 6 2 1 19 24 
Jan 20 15:19:42 uplift kernel: Sequencer SCB Info: 0(c 0x60, s 0x27, l 0, 
t 0xff) 1(c 0x60, s 0x17, 
l 0, t 0xff) 2(c 0x60, s 0x17, l 0, t 0xff) 3(c 0x60, s 0x7, l 0, t 0xff) 
4(c 0x60, s 0x37, l 0, t 0
xff) 5(c 0x60, s 0x37, l 0, t 0xff) 6(c 0x60, s 0x27, l 0, t 0xff) 7(c 
0x60, s 0x37, l 0, t 0xff) 8(
c 0x60, s 0x37, l 0, t 0xff) 9(c 0x60, s 0x37, l 0, t 0xff) 10(c 0x60, s 
0x27, l 0, t 0xff) 11(c 0x6
0, s 0x37, l 0, t 0xff) 12(c 0x60, s 0x37, l 0, t 0xff) 13(c 0x60, s 0x27, 
l 0, t 0xff) 14(c 0x60, s
 0x37, l 0, t 0xff) 15(c 0x60, s 0x37, l 0, t 0xff) 16(c 0x60, s 0x37, l 
0, t 0xff) 17(c 0x60, s 0x3
7, l 0, t 0xff) 18(c 0x60, s 0x7, l 0, t 0xff) 19(c 0x60, s 0x17, l 0, t 
0xff) 20(c 0x60, s 0x17, l 
0, t 0xff) 21(c 0x60, s 0x27, l 0, t 0xff) 22(c 0x60, s 0x37, l 0, t 0xff) 
23(c 0x60, s 0x37, l 0, t
 0xff) 24(c 0x60, s 0x17, l 0, t 0xff) 25(c 0x60, s 0x37, l 0, t 0xff) 
26(c 0x64, s 0x37, l 0, t 0x6
a) 27(c 0x60, s 0x37, l 0, t 0xff) 28(c 0x0, s 0x37, l 0, t 0xff) 29(c 
0x60, s 0x17, l 0, t 0xff) 30
(c 0x60, s 0x27, l 0, t 0x
Jan 20 15:19:42 uplift kernel: f) 31(c 0x60, s 0x37, l 0, t 0xff) 
Jan 20 15:19:42 uplift kernel: Pending list: 152(c 0x64, s 0x37, l 0), 
175(c 0x64, s 0x37, l 0), 121
(c 0x64, s 0x37, l 0), 138(c 0x64, s 0x37, l 0), 78(c 0x64, s 0x37, l 0), 
50(c 0x64, s 0x37, l 0), 2
29(c 0x64, s 0x37, l 0), 155(c 0x64, s 0x37, l 0), 129(c 0x64, s 0x37, l 
0), 106(c 0x64, s 0x37, l 0
)
Jan 20 15:19:43 uplift kernel: Kernel Free SCB list: 236 18 202 68 252 4 
156 23 118 57 146 174 135 9
4 184 83 76 140 177 231 190 52 180 139 86 132 126 145 224 65 114 239 7 92 
66 25 237 131 183 62 82 44
 179 226 153 60 235 5 71 240 167 13 225 67 22 171 136 166 88 54 85 59 55 
120 53 168 189 112 205 2 21
9 46 163 187 161 17 253 41 221 122 102 49 113 124 181 220 182 227 134 216 
209 64 169 36 69 110 61 23
2 144 233 95 37 159 162 230 72 77 214 24 222 197 70 31 35 210 15 117 48 
115 172 193 251 6 103 10 26 
199 127 142 84 248 143 213 212 178 185 16 109 100 96 80 242 63 196 223 203 
99 12 247 42 201 165 147 
164 74 51 11 188 191 56 234 39 21 27 176 79 97 243 119 111 104 204 14 34 
250 141 89 9 19 249 108 218
 151 137 198 150 130 154 8 38 246 81 125 195 157 149 107 194 0 47 170 244 
40 91 228 186 123 148 45 2
07 158 206 192 58 215 245 87 20 101 73 241 217 3 93 90 200 208 33 116 173 
75 98 128 211 105 133 238 
28 43 1 29 30 32 
Jan 20 15:19:43 uplift kernel: DevQ(0:0:0): 0 waiting
Jan 20 15:19:43 uplift kernel: DevQ(0:1:0): 0 waiting
Jan 20 15:19:43 uplift kernel: DevQ(0:2:0): 0 waiting
Jan 20 15:19:43 uplift kernel: DevQ(0:3:0): 0 waiting
Jan 20 15:19:43 uplift kernel: DevQ(0:4:0): 0 waiting
Jan 20 15:19:43 uplift kernel: DevQ(0:5:0): 0 waiting
Jan 20 15:19:43 uplift kernel: (scsi0:A:3:0): Queuing a recovery SCB
Jan 20 15:19:43 uplift kernel: scsi0:0:3:0: Device is disconnected, 
re-queuing SCB
Jan 20 15:19:43 uplift kernel: Recovery code sleeping
Jan 20 15:19:43 uplift kernel: (scsi0:A:3:0): Abort Tag Message Sent
Jan 20 15:19:43 uplift kernel: (scsi0:A:3:0): SCB 121 - Abort Tag 
Completed.
Jan 20 15:19:43 uplift kernel: Recovery SCB completes
Jan 20 15:19:43 uplift kernel: Recovery code awake
Jan 20 15:19:43 uplift kernel: aic7xxx_abort returns 0x2002
Jan 20 15:19:43 uplift kernel: scsi0:0:3:0: Attempting to queue an ABORT 
message
Jan 20 15:19:43 uplift kernel: scsi0:0:3:0: Command not found
Jan 20 15:19:43 uplift kernel: aic7xxx_abort returns 0x2002
Jan 20 15:19:43 uplift kernel: scsi0:0:3:0: Attempting to queue an ABORT 
message
Jan 20 15:19:43 uplift kernel: scsi0: Dumping Card State while idle, at 
SEQADDR 0x8
Jan 20 15:19:43 uplift kernel: ACCUM = 0x0, SINDEX = 0x79, DINDEX = 0xe4, 
ARG_2 = 0x0
Jan 20 15:19:43 uplift kernel: HCNT = 0x0 SCBPTR = 0x9
Jan 20 15:19:43 uplift kernel: SCSISEQ = 0x12, SBLKCTL = 0xa
Jan 20 15:19:43 uplift kernel:  DFCNTRL = 0x0, DFSTATUS = 0x89
Jan 20 15:19:43 uplift kernel: LASTPHASE = 0x1, SCSISIGI = 0x0, SXFRCTL0 = 
0x80
Jan 20 15:19:43 uplift kernel: SSTAT0 = 0x0, SSTAT1 = 0x8
Jan 20 15:19:43 uplift kernel: SCSIPHASE = 0x0
Jan 20 15:19:43 uplift kernel: STACK == 0x3, 0x108, 0x160, 0xe7
Jan 20 15:19:44 uplift kernel: SCB count = 254
Jan 20 15:19:44 uplift kernel: Kernel NEXTQSCB = 160
Jan 20 15:19:44 uplift kernel: Card NEXTQSCB = 160
Jan 20 15:19:44 uplift kernel: QINFIFO entries: 
Jan 20 15:19:44 uplift kernel: Waiting Queue entries: 
Jan 20 15:19:44 uplift kernel: Disconnected Queue entries: 26:106 
Jan 20 15:19:44 uplift kernel: QOUTFIFO entries: 

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

