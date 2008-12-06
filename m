From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] remove ide-scsi
Date: Sat, 6 Dec 2008 23:51:24 +0000
Message-ID: <20081206235124.00fe60fc@lxorguk.ukuu.org.uk>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>
	<200812062241.35601.bzolnier@gmail.com>
	<20081206222423.04aada70@lxorguk.ukuu.org.uk>
	<200812070040.49377.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200812070040.49377.bzolnier@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Dan =?ISO-8859-14?B?Tm/p?= <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
List-Id: linux-scsi@vger.kernel.org

> Unfortunately "generally" here means that once there is some more
> advanced driver functionality needed (i.e. error handling) it fails
> in the major way...  Thus leaving it there is confusing for users

Whereas removing it ensures it doesn't work in the first place, which is
a regression and pointless.

> Still, we can certainly leave ide-scsi there if you or somebody else
> want to maintain it (which didn't happen for the last year).  It would
> be best to start with fixing years long issues with error handling and
> taking the work on updating driver for IDE changes off my shoulder...

You could just stop turning the old IDE driver into an experimental
playground. The problems are only arising because old IDE is being
continually changed (frequently in directly the reverse direction it came
over the years)

Alan
