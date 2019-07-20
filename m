From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [GIT PULL] final round of SCSI updates for the 5.2+ merge window
Date: Sat, 20 Jul 2019 08:46:38 -0400
Message-ID: <yq14l3gx49d.fsf@oracle.com>
References: <1563579201.1602.7.camel@HansenPartnership.com>
        <CACVXFVNOPhiUhrgw07sna0dt5Jy2zckbNXDWPPRAGadXQAS_mQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACVXFVNOPhiUhrgw07sna0dt5Jy2zckbNXDWPPRAGadXQAS_mQ@mail.gmail.com>
        (Ming Lei's message of "Sat, 20 Jul 2019 10:29:40 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org


Hi Ming!

>> Christoph Hellwig (8):
>>       scsi: megaraid_sas: set an unlimited max_segment_size
>>       scsi: mpt3sas: set an unlimited max_segment_size for SAS 3.0 HBAs
>>       scsi: IB/srp: set virt_boundary_mask in the scsi host
>>       scsi: IB/iser: set virt_boundary_mask in the scsi host
>>       scsi: storvsc: set virt_boundary_mask in the scsi host template
>>       scsi: ufshcd: set max_segment_size in the scsi host template
>>       scsi: core: take the DMA max mapping size into account
>
> It has been observed on NVMe the above approach("take the DMA max
> mapping size into account") causes performance regression, so I'd
> suggest to fix dma_max_mapping_size() first.

Christoph specifically asked me to queue these up. I presume the swiotlb
tweak is going through his DMA tree and it is therefore orthogonal to
the SCSI changes.

I do think it's important that we get these fixed up in 5.3. And given
that we're on the eve of the merge window, the time to get these changes
merged is now. I'd hate to see them miss another release...

-- 
Martin K. Petersen	Oracle Linux Engineering
