From: Horms <horms@debian.org>
Subject: Re: Bug#338089: New aic7xxx driver fails spectacularly on 2940UW
Date: Wed, 16 Nov 2005 11:37:36 +0900
Message-ID: <20051116023734.GA1484@verge.net.au>
References: <1131904005.3291.5.camel@mulgrave> <20051115004520.31814.qmail@web88012.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from koto.vergenet.net ([210.128.90.7]:50091 "EHLO koto.vergenet.net")
	by vger.kernel.org with ESMTP id S965188AbVKPCm5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Nov 2005 21:42:57 -0500
Content-Disposition: inline
In-Reply-To: <20051115004520.31814.qmail@web88012.mail.re2.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Graham Knap <graham.knap@rogers.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Doug Ledford <dledford@redhat.com>, 338089@bugs.debian.org, linux-scsi@vger.kernel.org

On Mon, Nov 14, 2005 at 07:45:20PM -0500, Graham Knap wrote:
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> > Can you try with the attached patch, which will force DV to ignore
> > the echo buffer write tests?
> 
> I'll certainly try.
> 
> The kernel I was using was a prebuilt Debian kernel. I'm not sure how
> to rebuild it from source. Horms, if you could point me in the right
> direction, I'll give it a try. 

That depends exactly what you want to build. To just make an image
for testing, upacking the tarball supplied by linux-source-2.6.14,
using the config that came with linux-image-XYZ in /boot, and
optionally using make-kpkg, should work. Though I think you
have most of that happening.

> 
> For now, I've built a kernel using the linux-source-2.6.14 package
> (version 2.6.14-2). It's massively stripped down so that it compiles in
> a semi-reasonable amount of time on this very slow PC.

There isn't a great deal I can suggest in order to speed up builds,
except perhaps using ccache, or trimming the config as you have done.

If you need me to build stuff for you, I'm happy to oblige, 
though obviously there are extra email round-trips involved.

-- 
Horms
