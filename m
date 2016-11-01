From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND] mpt3sas: Fix for block device of raid exists even after deleting raid disk
Date: Tue, 01 Nov 2016 09:49:56 -0400
Message-ID: <yq137jb2ttn.fsf@sermon.lab.mkp.net>
References: <1477629552-27404-1-git-send-email-Sreekanth.Reddy@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1477629552-27404-1-git-send-email-Sreekanth.Reddy@broadcom.com>
        (Sreekanth Reddy's message of "Fri, 28 Oct 2016 10:09:12 +0530")
Sender: stable-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@broadcom.com> writes:

Sreekanth> While merging mpt3sas & mpt2sas code, we posted below patch
Sreekanth> for WarpDrive support,

[...]

Sreekanth> Due to above hunk, we are not initializing raid_device's
Sreekanth> starget for raid volumes, and so during raid disk deletion
Sreekanth> driver is not calling scsi_remove_target() API as driver
Sreekanth> observes starget field of raid_device's structure as NULL.

Applied to 4.9/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
