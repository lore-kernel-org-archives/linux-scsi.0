From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: New TRIM/UNMAP tree published (2009-05-02)
Date: Sun, 03 May 2009 14:37:56 -0500
Message-ID: <1241379476.5596.92.camel@mulgrave.int.hansenpartnership.com>
References: <1238683047-13588-1-git-send-email-willy@linux.intel.com>
	 <49D8A3D7.5070507@panasas.com> <20090503061150.GF10704@linux.intel.com>
	 <20090503071619.GP8822@parisc-linux.org>
	 <Pine.LNX.4.64.0905031346350.29671@blonde.anvils>
	 <20090503144847.GR8822@parisc-linux.org> <49FDB21B.3080301@panasas.com>
	 <20090503154216.GU8822@parisc-linux.org> <49FDC786.6070309@panasas.com>
	 <49FDE3BB.505@garzik.org>  <49FDE50A.4060503@garzik.org>
	 <1241377472.5596.88.camel@mulgrave.int.hansenpartnership.com>
	 <49FDEE64.5090302@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49FDEE64.5090302@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>, Hugh Dickins <hugh@veritas.com>, Matthew Wilcox <willy@linux.intel.com>, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Mark Lord <lkml@rtr.ca>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2009-05-03 at 15:20 -0400, Jeff Garzik wrote:
> Is WRITE SAME associated with this current DISCARD work, or is that just 
> a similar example?  I'm unfamiliar with its issues...

It's an adjunct body of work.  T10 apparently ratified both UNMAP and
the WRITE SAME extensions.  What WRITE SAME does is write the same data
block to multiple contiguous locations as specified in the CDB.  What
the thin provisioning update did for it is allow you to specify a flag
saying I want these sectors unmapped.   The perceived benefit of WRITE
SAME is that you specify (with the write same data ... presumably all
zeros) what an unmapped sector will return if it's ever read from again,
which was a big argument in the UNMAP case.

James


