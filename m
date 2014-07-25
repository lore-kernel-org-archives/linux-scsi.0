From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RESEND][PATCH 07/10][SCSI]mpt2sas: Added Reply Descriptor Post Queue (RDPQ) Array support
Date: Fri, 25 Jul 2014 15:43:16 -0400
Message-ID: <yq138dpgr6z.fsf@sermon.lab.mkp.net>
References: <20140625103445.GA12943@avagotech.com>
	<yq1zjg2m6lu.fsf@sermon.lab.mkp.net>
	<CAK=zhgoQt5J=jh4jShAy5rBXNz34sN-tqf=uZDkY4zQJ9XhM5g@mail.gmail.com>
	<yq18unklvda.fsf@sermon.lab.mkp.net>
	<CAK=zhgpDWJLBMBB1mV-7u+o_UC86PiOCAp4vi4-UAn_hXHtF2A@mail.gmail.com>
	<yq1r41bkgdp.fsf@sermon.lab.mkp.net>
	<CAK=zhgp_v_sdt+VLDs1Mxxi8Cg4nZNnzgQ=d228h+Ht2EpdEqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAK=zhgp_v_sdt+VLDs1Mxxi8Cg4nZNnzgQ=d228h+Ht2EpdEqw@mail.gmail.com>
	(Sreekanth Reddy's message of "Fri, 25 Jul 2014 18:27:08 +0530")
Sender: linux-kernel-owner@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sathya Prakash <Sathya.Prakash@avagotech.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@avagotech.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Sreekanth" == Sreekanth Reddy <sreekanth.reddy@avagotech.com> writes:

Sreekanth,

Sreekanth> Following are the changes that I have done in this patch over
Sreekanth> the first RDPQ support patch,

Please, please do the function moves in a different patch. Or use a
simple prototype declaration like I did to avoid moving the code around
in the first place.

Sreekanth> 2. Set pci_set_consistent_dma_mask() to
Sreekanth>    DMA_BIT_MASK(32). still I am analysing whether this change
Sreekanth>    may affect on any other things or not?

I think you're done allocating things by the time this is called. But to
be sure you can call _base_config_dma_addressing() after you're done
with the RDPQ allocations (or rearrange the code so you allocate RDPQ
before the DMA mask is upped in general).

-- 
Martin K. Petersen	Oracle Linux Engineering
