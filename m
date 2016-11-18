From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] mpt3sas: Fix for SATA drive in blocked state, after diag reset while ATA Passthrough command is outstanding.
Date: Thu, 17 Nov 2016 20:48:12 -0500
Message-ID: <yq1r3697e3n.fsf@sermon.lab.mkp.net>
References: <1479379558-1780-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1479379558-1780-1-git-send-email-suganath-prabu.subramani@broadcom.com>
        (Suganath Prabu S.'s message of "Thu, 17 Nov 2016 16:15:58 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Cc: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

>>>>> "Suganath" == Suganath Prabu S <suganath-prabu.subramani@broadcom.com> writes:

Suganath> While issuing any ATA Pass-through command to Firmware, driver
Suganath> will block the device, it will unblock the device only if that
Suganath> IO completes through ISR path. But if in-between any host
Suganath> reset occurs then driver won't unblock the device and device
Suganath> will be in blocked state.

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
