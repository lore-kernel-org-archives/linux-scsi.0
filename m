From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] fusion: streamline ->queuecommand
Date: Tue, 5 Oct 2004 16:37:14 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041005233714.GA18081@beaverton.ibm.com>
References: <0E3FA95632D6D047BA649F95DAB60E570526235F@exa-atlanta> <1097017890.1765.216.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:11180 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S266183AbUJEXiC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2004 19:38:02 -0400
Content-Disposition: inline
In-Reply-To: <1097017890.1765.216.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Eric Dean Moore <Emoore@lsil.com>, "Stephens, Larry" <larry.stephens@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>, "Gibbons, Terry" <Terry.Gibbons@lsil.com>, Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Oct 05, 2004 at 06:11:22PM -0500, James Bottomley wrote:

> However, the attitude that "my driver works and I've tested it, so I'm
> not going to change it" is in a large measure what got the SCSI subsytem
> into its pariah status in 2.4: too many in-driver work arounds and no
> thought to fixing the problems in the generic code.

Yes, we want drivers to move forward, but with our current model, we don't
have any 2.6.x kernel.org stable kernels. 

When we first went to this model I thought it did not matter, you could
just get stable kernels from a distro, but now I see problems with it.

If code changes for a mainline kernel scsi driver, there is no place to
keep a stable driver as part of a stable kernel.org series.

Driver maintainers are getting requests to backport current 2.6.x code to
distributions in order to support stable kernel series, else they have to
(effectively) maintain a driver version for each distro.

When we had 2.4 stable and 2.5 development, there was a single repository
for stable kernels, and one for development. Maintainers did not have to
track distros, the distros could (generally) pull from the latest 2.4.x
tree to sync up with the latest driver fixes.

-- Patrick Mansfield
