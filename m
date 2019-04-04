From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: storvsc: Reduce default ring buffer size to 128 Kbytes
Date: Wed, 03 Apr 2019 23:31:39 -0400
Message-ID: <yq14l7etpic.fsf@oracle.com>
References: <1554154871-10305-1-git-send-email-mikelley@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1554154871-10305-1-git-send-email-mikelley@microsoft.com>
        (Michael Kelley's message of "Mon, 1 Apr 2019 21:42:06 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kelley <mikelley@microsoft.com>
Cc: KY Srinivasan <kys@microsoft.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Long Li <longli@microsoft.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "emilne@redhat.com" <emilne@redhat.com>, "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Michael,

> Reduce the default VMbus channel ring buffer size for storvsc SCSI
> devices from 1 Mbyte to 128 Kbytes. Measurements show that ring buffer
> sizes above 128 Kbytes do not increase performance even at very high
> IOPS rates, so don't waste the memory. Also remove the dependence on
> PAGE_SIZE, since the ring buffer size should not change on
> architectures where PAGE_SIZE is not 4 Kbytes.

Applied to 5.1/scsi-fixes, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
