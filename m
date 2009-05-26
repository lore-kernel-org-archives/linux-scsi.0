From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
 buffer
Date: Tue, 26 May 2009 19:05:05 +0300
Message-ID: <4A1C1331.8060304@panasas.com>
References: <20090526073229.GC11363@kernel.dk>	<20090526163823U.fujita.tomonori@lab.ntt.co.jp>	<1243349222.2815.22.camel@localhost.localdomain> <20090527003152X.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090527003152X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com, rdreier@cisco.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/26/2009 06:31 PM, FUJITA Tomonori wrote:
> 
> Can we just fix some drivers not to do the DMA with the sense buffer in
> scsi_cmnd? IIRC, there are only five or six drivers that do such.

This is not so.
All drivers that go through scsi_eh_prep_cmnd() will eventually DMA through
the regular read path. Including all the drivers that do nothing and let
scsi-ml do the REQUEST_SENSE

Actually I have exact numbers, from the last time I did all that

Boaz
