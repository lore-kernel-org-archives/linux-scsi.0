From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/1] scsi: storvsc: Fix calculation of sub-channel count
Date: Wed, 03 Apr 2019 23:30:35 -0400
Message-ID: <yq18swqtpk4.fsf@oracle.com>
References: <1554134985-8671-1-git-send-email-mikelley@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1554134985-8671-1-git-send-email-mikelley@microsoft.com>
        (Michael Kelley's message of "Mon, 1 Apr 2019 16:10:52 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kelley <mikelley@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Long Li <longli@microsoft.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "emilne@redhat.com" <emilne@redhat.com>, "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Michael,

> When the number of sub-channels offered by Hyper-V is >= the number of
> CPUs in the VM, calculate the correct number of sub-channels.  The
> current code produces one too many.

Applied to 5.1/scsi-fixes, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
