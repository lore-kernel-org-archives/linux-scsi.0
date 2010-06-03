From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [Lsf10-pc] [LFS/VM TOPIC] Stable pages while IO (was Wrong DIF
	guard tag on ext2 write)
Date: Thu, 3 Jun 2010 12:30:01 -0400
Message-ID: <20100603163001.GF24994@fieldses.org>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com> <4C07D3D0.8010500@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C07D3D0.8010500@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, lsf10-pc@lists.linuxfoundation.org, Nick Piggin <npiggin@suse.de>, Al Viro <viro@ZenIV.linux.org.uk>, Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ric Wheeler <rwheeler@redhat.com>, Matthew Wilcox <willy@linux.intel.com>, Vladislav Bolkhovitin <vst@vlnb.net>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 03, 2010 at 07:09:52PM +0300, Boaz Harrosh wrote:
> [Topic]
> How to not let pages change while in IO
> 
> [Abstract]
> As seen in a long thread on the fsdvel scsi mailing lists. Lots of
> people have headaches and sleep less nights because individual pages
> can change while in IO and/or DMA. Though each one as slightly different
> needs, the mechanics look to be the same.
> 
> People that care:
> - Mirror and RAID people that need on disk consistency.
> - Network storage that wants data checksum.

Yes, nfs/rpcsec_gss code is an example of code that tries to sign pages
containing data that could change underneath us.  I don't know if we've
seen it in practice.

--b.

> - DIF/DIX people
> - ...
> 
> I for one know nothing of the subject but am a RAID person and would
> like a solution that does not force me to copy the complete data load.
> 
> Please lets get all the VM VFS and drivers people in one room and see
> if we can have a Linux solution to this problem
> 
> Boaz
> _______________________________________________
> Lsf10-pc mailing list
> Lsf10-pc@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/lsf10-pc
