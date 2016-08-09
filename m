From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas: Don't spam logs if logging level is 0
Date: Mon, 08 Aug 2016 21:28:02 -0400
Message-ID: <yq11t1yvihp.fsf@sermon.lab.mkp.net>
References: <1470229218-22040-1-git-send-email-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470229218-22040-1-git-send-email-jthumshirn@suse.de> (Johannes
	Thumshirn's message of "Wed, 3 Aug 2016 15:00:18 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Johannes" == Johannes Thumshirn <jthumshirn@suse.de> writes:

Johannes> In _scsih_io_done() we test if the ioc->logging_level does
Johannes> _not_ have the MPT_DEBUG_REPLY bit set and if it hasn't we
Johannes> print the debug messages. This unfortunately is the wrong way
Johannes> around.

Applied to 4.9/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
