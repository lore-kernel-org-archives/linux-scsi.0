From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v8 00/17] add fixes, device quirks, error recovery,
Date: Thu, 10 Mar 2016 21:36:46 -0500
Message-ID: <yq1k2l9lozl.fsf@sermon.lab.mkp.net>
References: <1457624241-20525-1-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1457624241-20525-1-git-send-email-ygardi@codeaurora.org> (Yaniv
	Gardi's message of "Thu, 10 Mar 2016 17:37:04 +0200")
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Yaniv" == Yaniv Gardi <ygardi@codeaurora.org> writes:

Yaniv> V8: fixed cyclic dependency by removing ufs_quirk.c that was
Yaniv> previously added in V7 06/17, and moving its code into ufshcd.c

Patch 6 is now different yet it retains Reviewed-by: tags from the
previous version. These should have been removed.

But if Hannes is OK with the changed version you don't need to
resend. Hannes, if you would be so kind to take a second look?

-- 
Martin K. Petersen	Oracle Linux Engineering
