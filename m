From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] remove ide-scsi
Date: Sun, 7 Dec 2008 00:09:29 +0000
Message-ID: <20081207000929.GU28946@ZenIV.linux.org.uk>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp> <200812061551.08525.bzolnier@gmail.com> <20081206120001.3580b9e3@tuna> <200812062241.35601.bzolnier@gmail.com> <20081206223307.GS28946@ZenIV.linux.org.uk> <150283e90812061517q61cd315fh90008659973d0b20@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:39841 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbYLGAJg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Dec 2008 19:09:36 -0500
Content-Disposition: inline
In-Reply-To: <150283e90812061517q61cd315fh90008659973d0b20@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <osst@riede.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Dan No?? <dpn@isomerica.net>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, Dec 06, 2008 at 04:17:55PM -0700, Willem Riede wrote:
> On Sat, Dec 6, 2008 at 3:33 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Sat, Dec 06, 2008 at 10:41:34PM +0100, Bartlomiej Zolnierkiewicz wrote:
> >
> >> It would be great but it seems like IDE OnStream drives are a real rarity
> >> nowadays (unfortunately I won't be of a much help here, don't have any)...
> >
> > I have one, actually.  If you want it sent your way...
> >
> If you would be willing to send it to me to replace the now defective drive I
> used to develop and maintain osst with, I'll test against libata.
> Contact me directly, if you would, to discuss arrangements.
> 
> Thanks, Willem Riede.

Argh...  Having tested them...  SC30 (SCSI one) is alive, DI30 is *not* ;-/
Sorry.
