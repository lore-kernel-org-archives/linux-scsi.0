From: Greg Banks <gnb@alphalink.com.au>
Subject: Re: [TRIVIAL] PATCH 2.5: kconfig sychronise banners (2_16)
Date: Fri, 09 Aug 2002 23:29:27 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D53C3B7.215BE462@alphalink.com.au>
References: <20020808032826.BA88E4A84@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Marcelo Tosatti <marcelo@conectiva.com.br>, geert@linux-m68k.org, linux-scsi@vger.kernel.org

Rusty Russell wrote:
> 
> In message <1028720141.18478.244.camel@irongate.swansea.linux.org.uk> you write
> :
> > On Wed, 2002-08-07 at 05:06, Rusty Trivial Russell wrote:
> > > From:  Greg Banks <gnb@alphalink.com.au>
> > >
> > >   2/5 definitions of CONFIG_BLK_DEV_SR have trivially different banners.
> >
> > 2.5 is wrong, 2.4 is right. At least according to Philips who invented
> > the things. Please submit the reverse diff to 2.5 8)
> 
> <SIGH>
>         CDROM seems pretty prevelent in the kernel over CD-ROM.

I counted them in 2.5 when I rolled this patch, it was CDROM 39, CD-ROM 15.

> Unification of the banners is a trivial first step to furthur removal
> of things that are gratuitously arch-dependent: this wasn't primarily
> a spelling fix.

Exactly.  CONFIG_BLK_DEV_SR was defined in 5 places, 3 of which spelled
it the wrong way; I chose to change the 2 correct spellings only because
that was a smaller diff.  The actual spelling in the corpus doesn't bother
me at all.

> s/CDROM/CD-ROM/ would probably come under the new "too trivial for
> trivial patch monkey rule" in normal circumstances 8)

I'm willing to do the changes if someone credible will send them to Linus
and Marcello.

Greg.
-- 
the price of civilisation today is a courageous willingness to prevail,
with force, if necessary, against whatever vicious and uncomprehending
enemies try to strike it down.     - Roger Sandall, The Age, 28Sep2001.
