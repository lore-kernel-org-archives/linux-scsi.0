From: Matt Domsch <Matt_Domsch@Dell.com>
Subject: [PATCH 2.5] megaraid driver updates 0/4
Date: Wed, 30 Oct 2002 16:10:43 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210301606300.29157-100000@humbolt.us.dell.com>
Reply-To: Matt Domsch <Matt_Domsch@Dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

This collects a series of fixes needed for the megaraid driver in 2.5.44 
BK-current.

James, please do a

	bk pull http://mdomsch.bkbits.net/linux-2.5-megaraid

This will update the following files:

 drivers/scsi/megaraid.c |  189 +-----------------------------------------------
 drivers/scsi/megaraid.h |    4 -
 2 files changed, 4 insertions, 189 deletions

through these ChangeSets:

<Matt_Domsch@dell.com> (02/10/30 1.871)
   megaraid: cleanups so it builds again

<Matt_Domsch@dell.com> (02/10/28 1.808.11.2)
   megaraid: s/pcibios_read_config/pci_read_config

<Matt_Domsch@dell.com> (02/10/22 1.808.11.1)
   megaraid: remove mega_{reorder,swap}_hosts
   
   Patch posted to l-k by Mike Anderson <andmike@us.ibm.com> on
   21-Oct-2002.


Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer, Architect
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com


