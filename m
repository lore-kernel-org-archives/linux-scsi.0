From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fusion: streamline ->queuecommand
Date: Wed, 6 Oct 2004 16:30:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041006143002.GA27262@lst.de>
References: <BC3CE0375D29D51199A400508B66CA6C0862AEFE@exc-snake.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:47522 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S269270AbUJFOaO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2004 10:30:14 -0400
Content-Disposition: inline
In-Reply-To: <BC3CE0375D29D51199A400508B66CA6C0862AEFE@exc-snake.co.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: "Gibbons, Terry" <Terry.Gibbons@lsil.com>
Cc: "'arjanv@redhat.com'" <arjanv@redhat.com>, 'James Bottomley' <James.Bottomley@SteelEye.com>, "Moore, Eric Dean" <Emoore@lsil.com>, "Stephens, Larry" <larry.stephens@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>, Matthew Wilcox <matthew@wil.cx>, SCSI Mailing List <linux-scsi@vger.kernel.org>

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

