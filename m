From: "Gibbons, Terry" <Terry.Gibbons@lsil.com>
Subject: RE: [PATCH] fusion: streamline ->queuecommand
Date: Wed, 6 Oct 2004 08:46:11 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <BC3CE0375D29D51199A400508B66CA6C0862AEFF@exc-snake.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42457 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S269273AbUJFOsK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2004 10:48:10 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "'arjanv@redhat.com'" <arjanv@redhat.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "Moore, Eric Dean" <Emoore@lsil.com>, "Stephens, Larry" <larry.stephens@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>, Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Cristoph, Matthew,

I agree that I really shouldn't be on this thread. I am not a Linux expert
and I haven't read this code.

I was copied because the very people that will resolve the issue, namely
Eric and Larry, included me as to bring support to their position that they
have a BIG problem and solutions aren't being mutually agreed upon.

Therefore, I'm the one chosen to take the unpopular stance of challenging
the status quo and asking for solutions as opposed to pushback on every
stance LSI has put forth.

Terry

-----Original Message-----
From: Christoph Hellwig [mailto:hch@lst.de]
Sent: Wednesday, October 06, 2004 8:30 AM
To: Gibbons, Terry
Cc: 'arjanv@redhat.com'; 'James Bottomley'; Moore, Eric Dean; Stephens,
Larry; Shirron, Stephen; Matthew Wilcox; SCSI Mailing List
Subject: Re: [PATCH] fusion: streamline ->queuecommand


On Wed, Oct 06, 2004 at 08:23:23AM -0600, Gibbons, Terry wrote:
> I stand corrected. Our customers will force driver patches through Red Hat
> and SuSE. They buy these products and keep Linux distributors in business.
> Do you expect our customers to take huge hits to their bottom line because
> DV will no longer execute properly on LSI devices?

You're totally missing the point.  No one wants to remove DV
functionality.  We want a single implementation of the DV mechanism in
the SPI transport class instead of various buggy copies in individual
drivers.

No may I kindly suggest that you stop trolling on this list and let your
staff handle this issue.  I'm pretty sure we can work out a solution
that suits everyone with Eric if we get the nonsensical managment issues
out of the loop.
