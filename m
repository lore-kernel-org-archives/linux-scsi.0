From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 2.6.13 1/20] aic94xx: Makefile
Date: Sat, 10 Sep 2005 14:26:23 +0200
Message-ID: <20050910122623.GD18845@mars.ravnborg.org>
References: <4321E335.5010805@adaptec.com> <20050909201834.GA24521@mipter.zuzino.mipt.ru> <20050909201435.GB9623@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750793AbVIJMYw@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050909201435.GB9623@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@ZenIV.linux.org.uk
Cc: Linus Torvalds <torvalds@osdl.org>, Luben Tuikov <luben_tuikov@adaptec.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Sep 09, 2005 at 09:14:35PM +0100, viro@ZenIV.linux.org.uk wrote:
> On Sat, Sep 10, 2005 at 12:18:34AM +0400, Alexey Dobriyan wrote:
> > On Fri, Sep 09, 2005 at 03:32:05PM -0400, Luben Tuikov wrote:
> > > --- linux-2.6.13-orig/drivers/scsi/aic94xx/Makefile
> > > +++ linux-2.6.13/drivers/scsi/aic94xx/Makefile
> > 
> > > +CHECK = sparse -Wbitwise
> > 
> > 	make C=1 CHECK="sparse -Wbitwise"
> > or
> > 	make C=1
> Or patch below and use make C=1 CF=-Wbitwise...
> 
> Allows to add to sparse arguments without mutilating makefiles - just
> pass CF=<arguments> and they will be added to CHECKFLAGS.

Applied - thanks.

	Sam
