From: Alex Davis <alex14641@yahoo.com>
Subject: SCSI Parity errors
Date: Fri, 20 Dec 2002 15:49:11 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021220234911.75094.qmail@web40506.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello

I am seeing the following message in my kernel log file:

Dec 20 13:36:28 alex kernel: scsi0: PCI error Interrupt at seqaddr = 0x9
Dec 20 13:36:28 alex kernel: scsi0: Data Parity Error Detected during address or write data phase
.
.
The message doesn't occur at regular intervals (several days
can pass between occurances), and I haven'tseen it occur when
the disk is being accessed.
The 'seqaddr' value is not always the same. The message occurs
even when there is no disk access. I haven't noticed any data 
loss though.

Hardware is Epox 8K7a motherboard, Adaptec 29160 Card, three 
Maxtor 36GB LVD 160 disks. I'm using a LVD-rated cable and
terminator. Term power is enabled on the last drive.

OS is Linux 2.4.19ac4




__________________________________________________
Do you Yahoo!?
Yahoo! Mail Plus - Powerful. Affordable. Sign up now.
http://mailplus.yahoo.com
