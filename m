From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] remove ide-scsi
Date: Sun, 7 Dec 2008 00:40:49 +0100
Message-ID: <200812070040.49377.bzolnier@gmail.com>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp> <200812062241.35601.bzolnier@gmail.com> <20081206222423.04aada70@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20081206222423.04aada70@lxorguk.ukuu.org.uk>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dan =?iso-8859-1?q?No=E9?= <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
List-Id: linux-scsi@vger.kernel.org

On Saturday 06 December 2008, Alan Cox wrote:
> > I think that for the time being it is best to just proceed with the removal
> > and see if there are any users needing the driver (+ we should probably try
> > SCSI/libata/osst path first).
> 
> Far better to just leave it there. It generally works for users so all

Unfortunately "generally" here means that once there is some more
advanced driver functionality needed (i.e. error handling) it fails
in the major way...  Thus leaving it there is confusing for users
which are better using either IDE native drivers or libata.  It is
also a waste of time on part of both IDE and SCSI people.

Still, we can certainly leave ide-scsi there if you or somebody else
want to maintain it (which didn't happen for the last year).  It would
be best to start with fixing years long issues with error handling and
taking the work on updating driver for IDE changes off my shoulder...

> you are doing is creating a regression with no possible benefit (other
> than encouraging people to move to libata so we can obsolete all of
> drivers/ide - which is what we really need to do and move the last few
> users over)

Please don't put my in the same box as I see no value added by libata
PATA to vast majority of IDE users.  However I certainly commend that you
want to take care of the last few OnStream users...

Thanks,
Bart
