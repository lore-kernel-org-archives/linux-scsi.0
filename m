From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: SCSI TMF processing; tag allocation
Date: Mon, 15 Nov 2010 14:40:29 +0000
Message-ID: <20101115144029.5c322b78@lxorguk.ukuu.org.uk>
References: <380694.87733.qm@web31812.mail.mud.yahoo.com>
	<20101113123750.GF18258@parisc-linux.org>
	<4CE0FD24.4030000@fusionio.com>
	<1289831595.2233.5.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1289831595.2233.5.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Matthew Wilcox <matthew@wil.cx>, Luben Tuikov <ltuikov@yahoo.com>, Greg KH <greg@kroah.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tj@kernel.org" <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

> Realistically, tag starvation isn't really a problem.  It was a known
> issue for 80s era hardware.  I've got some of the oldest drives on the
> planet and I didn't see a problem when the clock algorithm was removed
> from 53c700.

I'm not entirely sure that is the case at least for some early NCQ
capable ATA drives 8(
