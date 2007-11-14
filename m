From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Add missing $(obj) to aic7xxx makefile
Date: Wed, 14 Nov 2007 21:47:58 +0100
Message-ID: <20071114204758.GE10669@uranus.ravnborg.org>
References: <1193398273.8993.8.camel@grianne> <20071114203046.GA10669@uranus.ravnborg.org> <20071114203642.GA17785@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:50628 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258AbXKNUqV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Nov 2007 15:46:21 -0500
Content-Disposition: inline
In-Reply-To: <20071114203642.GA17785@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, linux-scsi@vger.kernel.org

On Wed, Nov 14, 2007 at 01:36:42PM -0700, Matthew Wilcox wrote:
> On Wed, Nov 14, 2007 at 09:30:46PM +0100, Sam Ravnborg wrote:
> > I had to modify the patch to make it actually work
> > reliable with "make drivers/scsi/ -j".
> > I have applied the below to kbuild.git.
> > 
> > linux-scsi cc'ed - please let me know if you prefer
> > to take it via scsi tree.
> 
> It seems independent of anything else that might come out of the scsi
> list.  Please take it via the kbuild tree.

I will do - thanks.

	Sam
