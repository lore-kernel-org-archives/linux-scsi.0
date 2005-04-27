From: Alex Guryanow <gav@nlr.ru>
Subject: clarification request about scsi-errors
Date: Wed, 27 Apr 2005 11:59:07 +0400
Message-ID: <98-1696222968.20050427115907@nlr.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from double.nlr.ru ([212.193.3.3]:44687 "EHLO nlr.ru")
	by vger.kernel.org with ESMTP id S261179AbVD0H7d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2005 03:59:33 -0400
Received: from localhost (localhost [127.0.0.1])
	by nlr.ru (Postfix) with ESMTP id B6F647334
	for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2005 11:59:31 +0400 (MSD)
Received: from nlr.ru ([127.0.0.1])
 by localhost (double [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
 id 28660-06 for <linux-scsi@vger.kernel.org>;
 Wed, 27 Apr 2005 11:59:20 +0400 (MSD)
Received: from guryanow2 (unknown [172.16.2.2])
	by nlr.ru (Postfix) with ESMTP id 5FD0C7305
	for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2005 11:59:12 +0400 (MSD)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

please clarify the errors that I have received from scsi-subsystem:
what is malfunctioning in my system?

I have RedHat Linux 8.0 with 2.4.23 kernel on IBM xSeries 232. Here is
my scsi-subsystem:

# cat /proc/scsi/aic7xxx/0
Adaptec AIC7xxx driver version: 6.2.36
Adaptec aic7899 Ultra160 SCSI adapter
aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
Allocated SCBs: 254, SG List Length: 102

Serial EEPROM:
0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a
0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a 0xc33a
0x08f4 0x585e 0x2807 0x0010 0x0300 0xffff 0xffff 0xffff
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0250 0xc250

Target 0 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
        Goal: 160.000MB/s transfers (80.000MHz DT, offset 63, 16bit)
        Curr: 160.000MB/s transfers (80.000MHz DT, offset 63, 16bit)
        Channel A Target 0 Lun 0 Settings
                Commands Queued 374680
                Commands Active 0
                Command Openings 64
                Max Tagged Openings 64
                Device Queue Frozen Count 0
Target 1 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
        Goal: 160.000MB/s transfers (80.000MHz DT, offset 63, 16bit)
        Curr: 160.000MB/s transfers (80.000MHz DT, offset 63, 16bit)
        Channel A Target 1 Lun 0 Settings
                Commands Queued 334172
                Commands Active 0
                Command Openings 64
                Max Tagged Openings 64
                Device Queue Frozen Count 0
Target 2 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
        Goal: 160.000MB/s transfers (80.000MHz DT, offset 63, 16bit)
        Curr: 160.000MB/s transfers (80.000MHz DT, offset 63, 16bit)
        Channel A Target 2 Lun 0 Settings
                Commands Queued 55487
                Commands Active 0
                Command Openings 128
                Max Tagged Openings 128
                Device Queue Frozen Count 0
Target 3 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 4 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 5 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 6 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 7 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 8 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
        Goal: 3.300MB/s transfers
        Curr: 3.300MB/s transfers
        Channel A Target 8 Lun 0 Settings
                Commands Queued 1
                Commands Active 0
                Command Openings 1
                Max Tagged Openings 0
                Device Queue Frozen Count 0
Target 9 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 10 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 11 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 12 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 13 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 14 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
Target 15 Negotiation Settings
        User: 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)



# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: IBM-ESXS Model: ST318305LC    !# Rev: B244
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: IBM-ESXS Model: ST318305LC    !# Rev: B244
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 02 Lun: 00
  Vendor: IBM-ESXS Model: IC35L036UCD210F  Rev: S5CJ
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 08 Lun: 00
  Vendor: IBM      Model: St  V1S2         Rev: 0
  Type:   Processor                        ANSI SCSI revision: 02



And here are the messages from syslog:

Apr 27 07:18:01 double kernel: scsi0:0:1:0: Attempting to queue an ABORT message
Apr 27 07:30:17 double kernel: CDB: 0x2a 0x0 0x1 0xb9 0x6a 0x71 0x0 0x0 0x2 0x0
Apr 27 07:30:18 double kernel: scsi0: At time of recovery, card was not paused
Apr 27 07:30:18 double kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Apr 27 07:30:18 double kernel: scsi0: Dumping Card State while idle, at SEQADDR 0x9
Apr 27 07:30:18 double kernel: Card was paused
Apr 27 07:30:18 double kernel: ACCUM = 0x0, SINDEX = 0xcc, DINDEX = 0xe4, ARG_2 = 0x0
Apr 27 07:30:18 double kernel: HCNT = 0x0 SCBPTR = 0x3
Apr 27 07:30:18 double kernel: SCSIPHASE[0x0] SCSISIGI[0x0] ERROR[0x0] SCSIBUSL[0x0] 
Apr 27 07:30:18 double kernel: LASTPHASE[0x1] SCSISEQ[0x12] SBLKCTL[0xa] SCSIRATE[0x0] 
Apr 27 07:30:18 double kernel: SEQCTL[0x10] SEQ_FLAGS[0xc0] SSTAT0[0x0] SSTAT1[0x8] 
Apr 27 07:30:18 double kernel: SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8] SIMODE1[0xa4] 
Apr 27 07:30:18 double kernel: SXFRCTL0[0x80] DFCNTRL[0x0] DFSTATUS[0x89] 
Apr 27 07:30:18 double kernel: STACK: 0xe1 0x163 0x109 0x3
Apr 27 07:30:18 double kernel: SCB count = 254
Apr 27 07:30:18 double kernel: Kernel NEXTQSCB = 61
Apr 27 07:30:18 double kernel: Card NEXTQSCB = 61
Apr 27 07:30:18 double kernel: QINFIFO entries: 
Apr 27 07:30:18 double kernel: Waiting Queue entries: 
Apr 27 07:30:18 double kernel: Disconnected Queue entries: 1:42 2:183 5:36 11:98 13:158 14:171
24:203 27:213 21:172 10:65 8:68 29:75 31:117 22:151 4:208 20:118 25:110 12:223 26:107 19:26 30:19
18:128 28:99 9:145 6:15 15:146 16:93 23:8 0:14 7:222 
Apr 27 07:30:18 double kernel: QOUTFIFO entries: 
Apr 27 07:30:18 double kernel: Sequencer Free SCB List: 3 17 
Apr 27 07:30:18 double kernel: Sequencer SCB Info: 
Apr 27 07:30:19 double kernel:   0 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xe] 
Apr 27 07:30:19 double kernel:   1 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x2a] 
Apr 27 07:30:19 double kernel:   2 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xb7] 
Apr 27 07:30:19 double kernel:   3 SCB_CONTROL[0xe0] SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:19 double kernel:   4 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xd0] 
Apr 27 07:30:19 double kernel:   5 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x24] 
Apr 27 07:30:19 double kernel:   6 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xf] 
Apr 27 07:30:19 double kernel:   7 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xde] 
Apr 27 07:30:19 double kernel:   8 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x44] 
Apr 27 07:30:19 double kernel:   9 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x91] 
Apr 27 07:30:19 double kernel:  10 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x41] 
Apr 27 07:30:19 double kernel:  11 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x62] 
Apr 27 07:30:19 double kernel:  12 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xdf] 
Apr 27 07:30:19 double kernel:  13 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x9e] 
Apr 27 07:30:19 double kernel:  14 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xab] 
Apr 27 07:30:19 double kernel:  15 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x92] 
Apr 27 07:30:19 double kernel:  16 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x5d] 
Apr 27 07:30:19 double kernel:  17 SCB_CONTROL[0xe0] SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:19 double kernel:  18 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x80] 
Apr 27 07:30:19 double kernel:  19 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x1a] 
Apr 27 07:30:19 double kernel:  20 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x76] 
Apr 27 07:30:19 double kernel:  21 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xac] 
Apr 27 07:30:19 double kernel:  22 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x97] 
Apr 27 07:30:19 double kernel:  23 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x8] 
Apr 27 07:30:19 double kernel:  24 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xcb] 
Apr 27 07:30:19 double kernel:  25 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x6e] 
Apr 27 07:30:19 double kernel:  26 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x6b] 
Apr 27 07:30:19 double kernel:  27 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xd5] 
Apr 27 07:30:19 double kernel:  28 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x63] 
Apr 27 07:30:19 double kernel:  29 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x4b] 
Apr 27 07:30:19 double kernel:  30 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x13] 
Apr 27 07:30:19 double kernel:  31 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0x75] 
Apr 27 07:30:19 double kernel: Pending list: 
Apr 27 07:30:19 double kernel: 111 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:19 double kernel: 233 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:19 double kernel: 245 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:20 double kernel:  79 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:20 double kernel:  48 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:21 double kernel: 161 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:21 double kernel:  96 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:21 double kernel: 139 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:21 double kernel: 153 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:21 double kernel: 218 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:21 double kernel: 113 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:21 double kernel: 167 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:21 double kernel: 131 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:21 double kernel: 132 SCB_CONT[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:21 double kernel:  23 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:21 double kernel:  24 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:21 double kernel:  25 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:21 double kernel:  26 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:21 double kernel:  27 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:21 double kernel:  28 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:21 double kernel:  29 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:21 double kernel:  30 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:21 double kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:21 double kernel: Pending list: 
Apr 27 07:30:21 double kernel: 111 SCB_CONTROL[0x60] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:21 double kernel: 233 SCB_CONTROL[0x74] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:21 double kernel: 222 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:21 double kernel: Kernel Free SCB list: 245 79 48 161 96 139 153 218 113 167 131 132
31 225 242 17 27 235 102 5 127 53 49 34 120 44 39 135 40 42 183 36 98 158 171 203 213 172 65 240 12
58 68 75 117 151 208 118 110 223 107 61 8 146 145 128 26 93 15 99 19 204 87 123 13 83 137 89 11 109
224 248 77 85 133 69 174 231 147 237 52 189 210 55 238 168 67 140 205 24 219 4 243 157 114 59 103
35 97 149 62 202 81 50 47 166 0 201 221 187 148 228 116 37 226 155 212 71 192 112 217 246 253 104
170 206 186 193 20 179 74 84 142 185 169 232 1 100 43 95 119 70 130 124 150 10 165 252 25 196 197
121 3 41 56 46 188 251 45 90 159 160 143 76 28 92 38 163 60 144 249 229 227 2 175 239 220 247 23
234 72 176 211 91 216 194 86 180 200 134 105 152 122 209 66 106 115 230 173 138 136 33 162 164 177
78 64 181 9 129 21 22 54 63 16 126 214 30 94 241 108 51 6 80 236 182 82 154 156 125 18 195 141 207
57 178 88 32 73 190 250 184 7 198 101 191 244 199 215 29 
Apr 27 07:30:21 double kernel: DevQ(0:0:0): 0 waiting
Apr 27 07:30:21 double kernel: DevQ(0:1:0): 0 waiting
Apr 27 07:30:21 double kernel: DevQ(0:2:0): 0 waiting
Apr 27 07:30:21 double kernel: DevQ(0:8:0): 0 waiting
Apr 27 07:30:21 double kernel: 
Apr 27 07:30:21 double kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Apr 27 07:30:21 double kernel: scsi0:0:1:0: Cmd aborted from QINFIFO
Apr 27 07:30:21 double kernel: aic7xxx_abort returns 0x2002
Apr 27 07:30:21 double kernel: scsi0:0:1:0: Attempting to queue an ABORT message
Apr 27 07:30:21 double kernel: CDB: 0x2a 0x0 0x1 0xb9 0xdc 0xbd 0x0 0x0 0x2 0x0
Apr 27 07:30:21 double kernel: scsi0:0:1:0: Command not found
Apr 27 07:30:21 double kernel: aic7xxx_abort returns 0x2002
Apr 27 07:30:22 double kernel: scsi0:0:1:0: Attempting to queue an ABORT message
Apr 27 07:30:22 double kernel: CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Apr 27 07:30:22 double kernel: scsi0: At time of recovery, card was not paused
Apr 27 07:30:22 double kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Apr 27 07:30:22 double kernel: scsi0: Dumping Card State in Message-out phase, at SEQADDR 0x16b
Apr 27 07:30:22 double kernel: Card was paused
Apr 27 07:30:22 double kernel: ACCUM = 0xa0, SINDEX = 0x61, DINDEX = 0xe4, ARG_2 = 0x37
Apr 27 07:30:22 double kernel: HCNT = 0x0 SCBPTR = 0x7
Apr 27 07:30:22 double kernel: SCSIPHASE[0x0] SCSISIGI[0xa4] ERROR[0x0] SCSIBUSL[0xd] 
Apr 27 07:30:22 double kernel: LASTPHASE[0xa0] SCSISEQ[0x12] SBLKCTL[0xa] SCSIRATE[0xc2] 
Apr 27 07:30:22 double kernel: SEQCTL[0x10] SEQ_FLAGS[0x40] SSTAT0[0x0] SSTAT1[0x0] 
Apr 27 07:30:22 double kernel: SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8] SIMODE1[0xac] 
Apr 27 07:30:22 double kernel: SXFRCTL0[0x88] DFCNTRL[0x0] DFSTATUS[0x89] 
Apr 27 07:30:22 double kernel: STACK: 0xe1 0xe1 0x163 0x178
Apr 27 07:30:22 double kernel: SCB count = 254
Apr 27 07:30:22 double kernel: Kernel NEXTQSCB = 111
Apr 27 07:30:22 double kernel: Card NEXTQSCB = 14
Apr 27 07:30:22 double kernel: QINFIFO entries: 14 233 
Apr 27 07:30:22 double kernel: Waiting Queue entries: 
Apr 27 07:30:22 double kernel: Disconnected Queue entries: 
Apr 27 07:30:22 double kernel: QOUTFIFO entries: 
Apr 27 07:30:22 double kernel: Sequencer Free SCB List: 1 2 5 11 13 14 24 27 21 10 8 29 31 22 4 20
25 12 26 19 30 18 28 9 6 15 16 23 0 3 17 
Apr 27 07:30:22 double kernel: Sequencer SCB Info: 
Apr 27 07:30:22 double kernel:   0 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:22 double kernel:   1 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:22 double kernel:   2 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:22 double kernel:   3 SCB_CONTROL[0xe0] SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:22 double kernel:   4 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:22 double kernel:   5 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:22 double kernel:   6 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:22 double kernel:   7 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xde] 
Apr 27 07:30:22 double kernel:   8 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:22 double kernel:   9 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:22 double kernel:  10 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:22 double kernel:  11 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:22 double kernel:  12 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:22 double kernel:  13 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:22 double kernel:  14 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:22 double kernel:  15 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:23 double kernel:  16 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:23 double kernel:  17 SCB_CONTROL[0xe0] SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:23 double kernel:  18 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:23 double kernel:  19 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:23 double kernel:  20 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:23 double kernel:  21 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:23 double kernel:  22 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:23 double kernel:  23 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:23 double kernel:  24 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:23 double kernel:  25 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:23 double kernel:  26 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:23 double kernel:  27 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:23 double kernel:  28 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:23 double kernel:  29 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:23 double kernel:  30 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:23 double kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:23 double kernel: Pending list: 
Apr 27 07:30:23 double kernel: 233 SCB_CONTROL[0x60] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:23 double kernel:  14 SCB_CONTROL[0x74] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:23 double kernel: 222 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:23 double kernel: Kernel Free SCB list: 245 79 48 161 96 139 153 218 113 167 131 132
31 225 242 17 27 235 102 5 127 53 49 34 120 44 39 135 40 42 183 36 98 158 171 203 213 172 65 240 12
58 68 75 117 151 208 118 110 223 107 61 8 146 145 128 26 93 15 99 19 204 87 123 13 83 137 89 11 109
224 248 77 85 133 69 174 231 147 237 52 189 210 55 238 168 67 140 205 24 219 4 243 157 114 59 103
35 97 149 62 202 81 50 47 166 0 201 221 187 148 228 116 37 226 155 212 71 192 112 217 246 253 104
170 206 186 193 20 179 74 84 142 185 169 232 1 100 43 95 119 70 130 124 150 10 165 252 25 196 197
121 3 41 56 46 188 251 45 90 159 160 143 76 28 92 38 163 60 144 249 229 227 2 175 239 220 247 23
234 72 176 211 91 216 194 86 180 200 134 105 152 122 209 66 106 115 230 173 138 136 33 162 164 177
78 64 181 9 129 21 22 54 63 16 126 214 30 94 241 108 51 6 80 236 182 82 154 156 125 18 195 141 207
57 178 88 32 73 190 250 184 7 198 101 191 244 199 215 29 
Apr 27 07:30:23 double kernel: DevQ(0:0:0): 0 waiting
Apr 27 07:30:23 double kernel: DevQ(0:1:0): 0 waiting
Apr 27 07:30:23 double kernel: DevQ(0:2:0): 0 waiting
Apr 27 07:30:23 double kernel: DevQ(0:8:0): 0 waiting
Apr 27 07:30:23 double kernel: 
Apr 27 07:30:23 double kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Apr 27 07:30:23 double kernel: scsi0:0:1:0: Cmd aborted from QINFIFO
Apr 27 07:30:23 double kernel: aic7xxx_abort returns 0x2002
Apr 27 07:30:23 double kernel: scsi0:0:1:0: Attempting to queue an ABORT message
Apr 27 07:30:23 double kernel: CDB: 0x2a 0x0 0x1 0xb9 0xfd 0xfb 0x0 0x0 0x2 0x0
Apr 27 07:30:23 double kernel: scsi0:0:1:0: Command not found
Apr 27 07:30:23 double kernel: aic7xxx_abort returns 0x2002
Apr 27 07:30:23 double kernel: scsi0:0:1:0: Attempting to queue an ABORT message
Apr 27 07:30:23 double kernel: CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Apr 27 07:30:23 double kernel: scsi0: At time of recovery, card was not paused
Apr 27 07:30:23 double kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Apr 27 07:30:23 double kernel: scsi0: Dumping Card State in Message-out phase, at SEQADDR 0x16b
Apr 27 07:30:23 double kernel: Card was paused
Apr 27 07:30:23 double kernel: ACCUM = 0xa0, SINDEX = 0x61, DINDEX = 0xe4, ARG_2 = 0x37
Apr 27 07:30:23 double kernel: HCNT = 0x0 SCBPTR = 0x7
Apr 27 07:30:23 double kernel: SCSIPHASE[0x0] SCSISIGI[0xa4] ERROR[0x0] SCSIBUSL[0xd] 
Apr 27 07:30:23 double kernel: LASTPHASE[0xa0] SCSISEQ[0x12] SBLKCTL[0xa] SCSIRATE[0xc2] 
Apr 27 07:30:23 double kernel: SEQCTL[0x10] SEQ_FLAGS[0x40] SSTAT0[0x0] SSTAT1[0x0] 
Apr 27 07:30:23 double kernel: SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8] SIMODE1[0xac] 
Apr 27 07:30:23 double kernel: SXFRCTL0[0x88] DFCNTRL[0x0] DFSTATUS[0x89] 
Apr 27 07:30:23 double kernel: STACK: 0xe1 0xe1 0x163 0x178
Apr 27 07:30:23 double kernel: SCB count = 254
Apr 27 07:30:23 double kernel: Kernel NEXTQSCB = 233
Apr 27 07:30:23 double kernel: Card NEXTQSCB = 111
Apr 27 07:30:23 double kernel: QINFIFO entries: 111 14 
Apr 27 07:30:24 double kernel: Waiting Queue entries: 
Apr 27 07:30:24 double kernel: Disconnected Queue entries: 
Apr 27 07:30:24 double kernel: QOUTFIFO entries: 
Apr 27 07:30:24 double kernel: Sequencer Free SCB List: 1 2 5 11 13 14 24 27 21 10 8 29 31 22 4 20
25 12 26 19 30 18 28 9 6 15 16 23 0 3 17 
Apr 27 07:30:24 double kernel: Sequencer SCB Info: 
Apr 27 07:30:24 double kernel:   0 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:   1 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:   2 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:   3 SCB_CONTROL[0xe0] SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:   4 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:   5 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:   6 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:   7 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xde] 
Apr 27 07:30:24 double kernel:   8 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:   9 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  10 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  11 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  12 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  13 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  14 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  15 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  16 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  17 SCB_CONTROL[0xe0] SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  18 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  19 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  20 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  21 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  22 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  23 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  24 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  25 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  26 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  27 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  28 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  29 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  30 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:24 double kernel: Pending list: 
Apr 27 07:30:24 double kernel:  14 SCB_CONTROL[0x60] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:24 double kernel: 111 SCB_CONTROL[0x74] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:24 double kernel: 222 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:24 double kernel: Kernel Free SCB list: 245 79 48 161 96 139 153 218 113 167 131 132
31 225 242 17 27 235 102 5 127 53 49 34 120 44 39 135 40 42 183 36 98 158 171 203 213 172 65 240 12
58 68 75 117 151 208 118 110 223 107 61 8 146 145 128 26 93 15 99 19 204 87 123 13 83 137 89 11 109
224 248 77 85 133 69 174 231 147 237 52 189 210 55 238 168 67 140 205 24 219 4 243 157 114 59 103
35 97 149 62 202 81 50 47 166 0 201 221 187 148 228 116 37 226 155 212 71 192 112 217 246 253 104
170 206 186 193 20 179 74 84 142 185 169 232 1 100 43 95 119 70 130 124 150 10 165 252 25 196 197
121 3 41 56 46 188 251 45 90 159 160 143 76 28 92 38 163 60 144 249 229 227 2 175 239 220 247 23
234 72 176 211 91 216 194 86 180 200 134 105 152 122 209 66 106 115 230 173 138 136 33 162 164 177
78 64 181 9 129 21 22 54 63 16 126 214 30 94 241 108 51 6 80 236 182 82 154 156 125 18 195 141 207
57 178 88 32 73 190 250 184 7 198 101 191 244 199 215 29 
Apr 27 07:30:24 double kernel: DevQ(0:0:0): 0 waiting
Apr 27 07:30:24 double kernel: DevQ(0:1:0): 0 waiting
Apr 27 07:30:24 double kernel: DevQ(0:2:0): 0 waiting
Apr 27 07:30:24 double kernel: DevQ(0:8:0): 0 waiting
Apr 27 07:30:24 double kernel: 
Apr 27 07:30:24 double kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Apr 27 07:30:24 double kernel: scsi0:0:1:0: Cmd aborted from QINFIFO
Apr 27 07:30:25 double kernel: aic7xxx_abort returns 0x2002
Apr 27 07:30:25 double kernel: scsi0:0:1:0: Attempting to queue an ABORT message
Apr 27 07:30:25 double kernel: CDB: 0x2a 0x0 0x1 0xba 0x37 0xfd 0x0 0x0 0x2 0x0
Apr 27 07:30:25 double kernel: scsi0:0:1:0: Command not found
Apr 27 07:30:25 double kernel: aic7xxx_abort returns 0x2002
Apr 27 07:30:25 double kernel: scsi0:0:1:0: Attempting to queue an ABORT message
Apr 27 07:30:25 double kernel: CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Apr 27 07:30:25 double kernel: scsi0: At time of recovery, card was not paused
Apr 27 07:30:25 double kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Apr 27 07:30:25 double kernel: scsi0: Dumping Card State in Message-out phase, at SEQADDR 0x16b
Apr 27 07:30:25 double kernel: Card was paused
Apr 27 07:30:25 double kernel: ACCUM = 0xa0, SINDEX = 0x61, DINDEX = 0xe4, ARG_2 = 0x37
Apr 27 07:30:25 double kernel: HCNT = 0x0 SCBPTR = 0x7
Apr 27 07:30:25 double kernel: SCSIPHASE[0x0] SCSISIGI[0xa4] ERROR[0x0] SCSIBUSL[0xd] 
Apr 27 07:30:25 double kernel: LASTPHASE[0xa0] SCSISEQ[0x12] SBLKCTL[0xa] SCSIRATE[0xc2] 
Apr 27 07:30:25 double kernel: SEQCTL[0x10] SEQ_FLAGS[0x40] SSTAT0[0x0] SSTAT1[0x0] 
Apr 27 07:30:25 double kernel: SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8] SIMODE1[0xac] 
Apr 27 07:30:25 double kernel: SXFRCTL0[0x88] DFCNTRL[0x0] DFSTATUS[0x89] 
Apr 27 07:30:25 double kernel: STACK: 0xe1 0xe1 0x163 0x178
Apr 27 07:30:25 double kernel: SCB count = 254
Apr 27 07:30:25 double kernel: Kernel NEXTQSCB = 14
Apr 27 07:30:25 double kernel: Card NEXTQSCB = 233
Apr 27 07:30:25 double kernel: QINFIFO entries: 233 111 
Apr 27 07:30:25 double kernel: Waiting Queue entries: 
Apr 27 07:30:25 double kernel: Disconnected Queue entries: 
Apr 27 07:30:25 double kernel: QOUTFIFO entries: 
Apr 27 07:30:25 double kernel: Sequencer Free SCB List: 1 2 5 11 13 14 24 27 21 10 8 29 31 22 4 20
25 12 26 19 30 18 28 9 6 15 16 23 0 3 17 
Apr 27 07:30:25 double kernel: Sequencer SCB Info: 
Apr 27 07:30:25 double kernel:   0 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:25 double kernel:   1 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:25 double kernel:   2 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:25 double kernel:   3 SCB_CONTROL[0xe0] SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:25 double kernel:   4 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:25 double kernel:   5 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:25 double kernel:   6 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:25 double kernel:   7 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xde] 
Apr 27 07:30:25 double kernel:   8 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:25 double kernel:   9 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:25 double kernel:  10 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:25 double kernel:  11 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:25 double kernel:  12 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:25 double kernel:  13 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:25 double kernel:  14 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:25 double kernel:  15 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:25 double kernel:  16 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:25 double kernel:  17 SCB_CONTROL[0xe0] SCB_SCSIID[0x7] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:25 double kernel:  18 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:25 double kernel:  19 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:25 double kernel:  20 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:25 double kernel:  21 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:26 double kernel:  22 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:26 double kernel:  23 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:26 double kernel:  24 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:26 double kernel:  25 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:26 double kernel:  26 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:26 double kernel:  27 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:26 double kernel:  28 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:26 double kernel:  29 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:26 double kernel:  30 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:26 double kernel:  31 SCB_CONTROL[0x0] SCB_SCSIID[0x17] SCB_LUN[0x0] SCB_TAG[0xff] 
Apr 27 07:30:26 double kernel: Pending list: 
Apr 27 07:30:26 double kernel: 111 SCB_CONTROL[0x60] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:26 double kernel: 233 SCB_CONTROL[0x74] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:26 double kernel: 222 SCB_CONTROL[0x64] SCB_SCSIID[0x17] SCB_LUN[0x0] 
Apr 27 07:30:26 double kernel: Kernel Free SCB list: 245 79 48 161 96 139 153 218 113 167 131 132
31 225 242 17 27 235 102 5 127 53 49 34 120 44 39 135 40 42 183 36 98 158 171 203 213 172 65 240 12
58 68 75 117 151 208 118 110 223 107 61 8 146 145 128 26 93 15 99 19 204 87 123 13 83 137 89 11 109
224 248 77 85 133 69 174 231 147 237 52 189 210 55 238 168 67 140 205 24 219 4 243 157 114 59 103
35 97 149 62 202 81 50 47 166 0 201 221 187 148 228 116 37 226 155 212 71 192 112 217 246 253 104
170 206 186 193 20 179 74 84 142 185 169 232 1 100 43 95 119 70 130 124 150 10 165 252 25 196 197
121 3 41 56 46 188 251 45 90 159 160 143 76 28 92 38 163 60 144 249 229 227 2 175 239 220 247 23
234 72 176 211 91 216 194 86 180 200 134 105 152 122 209 66 106 115 230 173 138 136 33 162 164 177
78 64 181 9 129 21 22 54 63 16 126 214 30 94 241 108 51 6 80 236 182 82 154 156 125 18 195 141 207
57 178 88 32 73 190 250 184 7 198 101 191 244 199 215 29 
Apr 27 07:30:26 double kernel: DevQ(0:0:0): 0 waiting
Apr 27 07:30:26 double kernel: DevQ(0:1:0): 0 waiting
Apr 27 07:30:26 double kernel: DevQ(0:2:0): 0 waiting
Apr 27 07:30:26 double kernel: DevQ(0:8:0): 0 waiting
Apr 27 07:30:26 double kernel: 
Apr 27 07:30:26 double kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Apr 27 07:30:26 double kernel: scsi0:0:1:0: Cmd aborted from QINFIFO
Apr 27 07:30:26 double kernel: aic7xxx_abort returns 0x2002
Apr 27 07:30:26 double kernel: scsi0:0:1:0: Attempting to queue a TARGET RESET message
Apr 27 07:30:26 double kernel: CDB: 0x2a 0x0 0x1 0xb9 0x6a 0x71 0x0 0x0 0x2 0x0
Apr 27 07:30:26 double kernel: aic7xxx_dev_reset returns 0x2003
Apr 27 07:30:26 double kernel: Recovery SCB completes
Apr 27 07:30:26 double kernel: Recovery SCB completes


sometimes these logs are finished with

Apr 27 09:32:02 double kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Apr 27 09:32:02 double kernel: Recovery SCB completes
Apr 27 09:32:02 double kernel: (scsi0:A:1:0): Device is disconnected, re-queuing SCB


Am I right that this is hardware problem with my second ST318305LC
harddisk? Or may be it's a scsi-controller failure?


Best regards,
Alex

