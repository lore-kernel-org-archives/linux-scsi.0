From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] remove ide-scsi
Date: Sat, 6 Dec 2008 22:24:23 +0000
Message-ID: <20081206222423.04aada70@lxorguk.ukuu.org.uk>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>
	<200812061551.08525.bzolnier@gmail.com>
	<20081206120001.3580b9e3@tuna>
	<200812062241.35601.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200812062241.35601.bzolnier@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Dan =?ISO-8859-14?B?Tm/p?= <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org
List-Id: linux-scsi@vger.kernel.org

> I think that for the time being it is best to just proceed with the removal
> and see if there are any users needing the driver (+ we should probably try
> SCSI/libata/osst path first).

Far better to just leave it there. It generally works for users so all
you are doing is creating a regression with no possible benefit (other
than encouraging people to move to libata so we can obsolete all of
drivers/ide - which is what we really need to do and move the last few
users over)

Alan
