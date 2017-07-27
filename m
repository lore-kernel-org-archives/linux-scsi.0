From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch 0/5] scsi/bnx2*: Plug hotplug race, correct locking and simplify hotplug code
Date: Wed, 26 Jul 2017 21:58:38 -0400
Message-ID: <yq1a83qy71t.fsf@oracle.com>
References: <20170724105255.715647116@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170724105255.715647116@linutronix.de> (Thomas Gleixner's
        message of "Mon, 24 Jul 2017 12:52:55 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, QLogic-Storage-Upstream@qlogic.com, martin.petersen@oracle.com, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
List-Id: linux-scsi@vger.kernel.org


Thomas,

> The conversion of the cpu hotplug locking to a percpu rwsem does not
> longer allow recursive locking of the hotplug lock.
>
> The BNX2I and BNX2FC drivers install/remove hotplug states with the
> hotplug lock held. The install/removal code acquired the hotplug lock
> as well.
>
> While looking into this, I noticed an interesting hotplug race in the
> BNX2FC driver, which could result in dereferencing a NULL pointer or
> freed and potentially reused memory.
>
> The following series addresses these problems and as a final step on
> top it simplifies the hotplug code in both drivers.

Applied to 4.13/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
