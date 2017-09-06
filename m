From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] bsg-lib: fix kernel panic resulting from missing
 allocation of reply-buffer
Date: Wed, 6 Sep 2017 16:15:09 +0200
Message-ID: <20170906141509.GB8702@bblock-ThinkPad-W530>
References: <20170906134416.19980-1-hch@lst.de>
 <20170906134416.19980-2-hch@lst.de>
 <42e9ef4d-6981-2b0c-bdc3-afb5b1750666@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <42e9ef4d-6981-2b0c-bdc3-afb5b1750666@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, "#4 . 11+" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 06, 2017 at 08:07:43AM -0600, Jens Axboe wrote:
> On 09/06/2017 07:44 AM, Christoph Hellwig wrote:
> > From: Benjamin Block <bblock@linux.vnet.ibm.com>
> > 
> > Since we split the scsi_request out of struct request bsg fails to
> > provide a reply-buffer for the drivers. This was done via the pointer
> > for sense-data, that is not preallocated anymore.
> 
> Confused, this is already in master, was included before 4.13 was
> finalized.
> 

I think this is the backport for 4.11 and 4.12 as requested by Greg. I
just send a mail as answer that I would do it, but I guess Christoph
already had something in the pipe.

Or? I'll take a look.


                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block
-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
