From: devnetfs <devnetfs@yahoo.com>
Subject: dev nodes assignement ?
Date: Wed, 29 Jan 2003 03:00:04 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030129110004.22210.qmail@web20421.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

Is /dev/sdX scsi dev node assignment based *only* on the pci-slot
the HBA's are in? or also upon the order in which the LLDD is loaded?

In other words does the mid-layer scan+make-a-list of all HBA's on
the system (and thereby assigning the /dev name) and then when a LLDD
is loaded, tells it the HBA-list? 
OR
Does each LLDD does a pci-scan and assign /dev name for HBA's that it
can handle -- in which case the order of LLDD getting loaded is also
important in deciding the /dev/sdX name.

Please clarify, 
Thanks in advance
A.

__________________________________________________
Do you Yahoo!?
Yahoo! Mail Plus - Powerful. Affordable. Sign up now.
http://mailplus.yahoo.com
