From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v8 00/17] add fixes, device quirks, error recovery,
Date: Mon, 14 Mar 2016 15:59:27 -0400
Message-ID: <yq1mvq0j0f4.fsf@sermon.lab.mkp.net>
References: <1457624241-20525-1-git-send-email-ygardi@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1457624241-20525-1-git-send-email-ygardi@codeaurora.org> (Yaniv
	Gardi's message of "Thu, 10 Mar 2016 17:37:04 +0200")
Sender: linux-arm-msm-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Yaniv" == Yaniv Gardi <ygardi@codeaurora.org> writes:

Yaniv> V8: fixed cyclic dependency by removing ufs_quirk.c that was
Yaniv> previously added in V7 06/17, and moving its code into ufshcd.c

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
