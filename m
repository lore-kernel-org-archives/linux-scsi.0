From: "Gibbons, Terry" <Terry.Gibbons@lsil.com>
Subject: RE: [PATCH] fusion: streamline ->queuecommand
Date: Wed, 6 Oct 2004 08:23:23 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <BC3CE0375D29D51199A400508B66CA6C0862AEFE@exc-snake.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42454 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S269259AbUJFOZ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2004 10:25:27 -0400
List-Id: linux-scsi@vger.kernel.org
To: "'arjanv@redhat.com'" <arjanv@redhat.com>
Cc: 'James Bottomley' <James.Bottomley@SteelEye.com>, "Moore, Eric Dean" <Emoore@lsil.com>, "Stephens, Larry" <larry.stephens@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>, Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

I stand corrected. Our customers will force driver patches through Red Hat
and SuSE. They buy these products and keep Linux distributors in business.
Do you expect our customers to take huge hits to their bottom line because
DV will no longer execute properly on LSI devices?

Maybe we should change the focus. What are your suggestions for making sure
that every major server vendor isn't negatively impacted by changes to DV? 

As for your last paragraph, I'm saying that there are more important and
pressing issues to be tackled than one issue on an old technology.

Terry

 -----Original Message-----
From: 	Arjan van de Ven [mailto:arjanv@redhat.com] 
Sent:	Wednesday, October 06, 2004 8:14 AM
To:	Gibbons, Terry
Cc:	'James Bottomley'; Moore, Eric Dean; Stephens, Larry; Shirron,
Stephen; Matthew Wilcox; Christoph Hellwig; SCSI Mailing List
Subject:	RE: [PATCH] fusion: streamline ->queuecommand

 << File: signature.asc >> On Wed, 2004-10-06 at 16:00, Gibbons, Terry
wrote:
> A change in DV code will result in lost time to LSI, Red Hat, SuSE, and
all
> of LSI's customers as there will be absolutely no choice but to force LSI
> driver patches for DV through Red Hat and SuSE (at a minimum).

I personally object to your terminology here. LSI cannot force any
patches through Red Hat, and I suspect the same holds for SuSE. LSI can
request patch inclusion which Red Hat or SuSE may or may not decide to
do. I can't speak for SuSE but RH seems to not be a great fan of huge
driver patches that deviate from what is available and tested upstream.


> Now, I challenge all of you. Ultra320 SCSI was fully released over two and
a
> half years ago. With SAS and SATA being the new technologies, what's the
> benefit in changing a technology that is peaking and soon to be replaced?

If you are unmaintaining the driver just say so. If you're not, please
consider the fact that we have to work with your code, and that we have
to keep making sure your driver works with "our" scsi stack. Previously
the linux scsi layer became a really big mess this way because drivers
just never changed and no real innovation was possible as a result.
Times have changed, the scsi layer now is actively maintained and moving
forward both in code quality, reliability and functionality. Your
statement seems to suggest you want to hold back linux scsi....

