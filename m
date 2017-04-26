From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH 07/10][SCSI]mpt2sas: Added Reply Descriptor Post Queue (RDPQ) Array support
Date: Wed, 26 Apr 2017 18:25:23 -0400
Message-ID: <yq1mvb2ajsc.fsf@oracle.com>
References: <20140625103445.GA12943@avagotech.com>
        <yq1zjg2m6lu.fsf@sermon.lab.mkp.net>
        <CAK=zhgoQt5J=jh4jShAy5rBXNz34sN-tqf=uZDkY4zQJ9XhM5g@mail.gmail.com>
        <yq18unklvda.fsf@sermon.lab.mkp.net>
        <CAK=zhgpDWJLBMBB1mV-7u+o_UC86PiOCAp4vi4-UAn_hXHtF2A@mail.gmail.com>
        <yq1r41bkgdp.fsf@sermon.lab.mkp.net>
        <CAK=zhgq=DfOZGjLcid4qJA+L_Vs4UjOHAmJza5Zh-V7u=LxcsQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK=zhgq=DfOZGjLcid4qJA+L_Vs4UjOHAmJza5Zh-V7u=LxcsQ@mail.gmail.com>
        (Sreekanth Reddy's message of "Tue, 25 Apr 2017 17:21:07 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "jejb@kernel.org" <jejb@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org


Sreekanth,

> We need to satisfy this condition on those system where 32 bit dma
> consistent mask is not supported and it only supports 64 bit dma
> consistent mask. So on these system we can't set
> pci_set_consistent_dma_mask() to DMA_BIT_MASK(32).

Which systems are you talking about?

It seems a bit unrealistic to require all devices to support 64-bit DMA.

-- 
Martin K. Petersen	Oracle Linux Engineering
