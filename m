From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] remove ide-scsi
Date: Sat, 6 Dec 2008 17:29:15 +0100
Message-ID: <200812061729.15895.bzolnier@gmail.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp> <200812061551.08525.bzolnier@gmail.com> <20081206150625.224aa97f@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20081206150625.224aa97f@lxorguk.ukuu.org.uk>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
List-Id: linux-scsi@vger.kernel.org

On Saturday 06 December 2008, Alan Cox wrote:
> > ide-scsi has been practically a dead code for a long time now (IIRC it has
> > even been broken -- by some general kernel changes -- for few releases and
> > nobody noticed, till Boaz discovered it while doing unrelated SCSI fixes)
> > but I kept it on the live support anyway.  However there needs to be some
> > limit to it, especially given that driver has been officially orphaned for
> > over a year now and nobody stepped in...
> 
> And it basically still works. You've just removed some hardware support
> for folks still trapped with the old IDE legacy drivers and some tape
> drives etc.

Please note that I already offered to put my time into helping people
potentially affected by the change.

> I shall certainly be asking Linus not to apply your changeset.

If you actually cared about such folks (whose must be really tough on
their luck since both IDE/ide-tape and SCSI/libata/st+osst should cover
99.9% of tape drives) you would be proposing constructive solutions
(i.e. offering better libata PATA support) instead of threats.

Thanks,
Bart

PS Looking at the patch history since 2002 (I'm lazy I didn't look past
tglx's tree) it was mostly Willem, James or me who paid the cost of keeping
ide-scsi and were targetted with insane bugreports.  Your actual ide-scsi
contributions in the meantime are near non-existing and I think that it
could account into the weight of your voice...
