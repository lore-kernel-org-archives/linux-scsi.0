From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: storvsc: Always use blk-mq
Date: Wed, 19 Dec 2018 21:51:04 -0500
Message-ID: <yq14lb8gbc7.fsf@oracle.com>
References: <1545243282-10573-1-git-send-email-mikelley@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545243282-10573-1-git-send-email-mikelley@microsoft.com>
        (Michael Kelley's message of "Wed, 19 Dec 2018 18:40:49 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kelley <mikelley@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>, Stephen Hemminger <sthemmin@microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Long Li <longli@microsoft.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "emilne@redhat.com" <emilne@redhat.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Michael,

> With high IOPS storage being increasingly prevalent for guests
> on Hyper-V and in Azure, make blk-mq the default so that the
> full performance of the storage can be realized without having
> to tweak other configuration settings.

The legacy I/O path will be gone in 4.21 so this patch isn't needed.

-- 
Martin K. Petersen	Oracle Linux Engineering
