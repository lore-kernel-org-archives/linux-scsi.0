From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 0/3] scsi: reduce CONFIG_SCSI_CONSTANTS=y impact by 8k
Date: Wed, 23 Mar 2016 16:50:56 -0400
Message-ID: <yq1r3f02a1b.fsf@sermon.lab.mkp.net>
References: <20160322075405.GA20141@infradead.org>
	<1458675126-19265-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1458675126-19265-1-git-send-email-linux@rasmusvillemoes.dk>
	(Rasmus Villemoes's message of "Tue, 22 Mar 2016 20:32:02 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Rasmus" == Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:

Rasmus> This is mostly identical to v2 sent in November, rebased
Rasmus> (cleanly) to current mainline. The only change is that I've this
Rasmus> time also updated the Kconfig help text in 3/3, since the 75 KB
Rasmus> was a bit exaggerated. After these patches are applied, the
Rasmus> impact of choosing CONFIG_SCSI_CONSTANTS=y is about 36 KB, while
Rasmus> it was about 44 KB before. I took the liberty of including
Rasmus> Hannes' Reviewed-by and Douglas' Tested-by despite that
Rasmus> addition.

Applied to 4.7/scsi-queue.

Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
