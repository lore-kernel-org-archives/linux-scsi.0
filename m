From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: mvsas: fix indenting on return error code
Date: Wed, 06 Jan 2016 15:29:03 -0500
Message-ID: <yq1y4c2ih9s.fsf@sermon.lab.mkp.net>
References: <1451995000-9210-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1451995000-9210-1-git-send-email-colin.king@canonical.com>
	(Colin King's message of "Tue, 5 Jan 2016 11:56:40 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Tomas Henzl <thenzl@redhat.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Colin" == Colin King <colin.king@canonical.com> writes:

Colin,

Colin> The return code and error return is incorrectly indented which
Colin> may cause some confusion as it appears at first sight to be
Colin> associated with a device not ready error (with missing { }
Colin> braces) rather than a DEV_IS_GONE() failure.

This problem has already been addressed:

https://git.kernel.org/cgit/linux/kernel/git/mkp/scsi.git/commit/?h=4.5/scsi-queue&id=7789cd39274c

-- 
Martin K. Petersen	Oracle Linux Engineering
