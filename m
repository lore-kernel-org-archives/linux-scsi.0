From: devnetfs <devnetfs@yahoo.com>
Subject: what does RECOVERED ERROR sense key mean?
Date: Wed, 15 Jan 2003 23:43:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030116074316.35203.qmail@web20421.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I am trying to reserve a disk using SCSI_IOCTL_SEND_COMMAND ioctl.

Sometimes I get SCSI error code=0x2 (ioctl returns this value). From 
the "Linux SCSI Generic HOWTO", above code is a 4-byte compacted error 
code. Here for 0x2 it means: status_byte == CHECK_CONDITION. The Sense
Key I get is 0x1 i.e. "RECOVERED ERROR".

>From the "SCSI Programming HOWTO", "RECOVERED ERROR" means:
---
"Indicates that the last command completed successfully with some
recovery action performed by the target. Details may be determinable 
by examining the additional sense bytes and the information field.
When multiple recovered errors occur during one command, the choice of
which error to report (first, last, most severe, etc.) is device 
specific."
---

So my question is: can I ASSUME that when I get this error(0x2) and
sensekey (0x1) my RESERVER was successful? or should I again retry?

Thanks in Advance,
A.


__________________________________________________
Do you Yahoo!?
Yahoo! Mail Plus - Powerful. Affordable. Sign up now.
http://mailplus.yahoo.com
