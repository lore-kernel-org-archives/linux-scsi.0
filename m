From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [TRIVIAL] PATCH 2.5: kconfig sychronise banners (2_16)
Date: Thu, 08 Aug 2002 12:10:18 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020808032826.BA88E4A84@lists.samba.org>
References: <1028720141.18478.244.camel@irongate.swansea.linux.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: Your message of "07 Aug 2002 12:35:41 +0100."
             <1028720141.18478.244.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, geert@linux-m68k.org, linux-scsi@vger.kernel.org, Greg Banks <gnb@alphalink.com.au>

In message <1028720141.18478.244.camel@irongate.swansea.linux.org.uk> you write
:
> On Wed, 2002-08-07 at 05:06, Rusty Trivial Russell wrote:
> > From:  Greg Banks <gnb@alphalink.com.au>
> > 
> > (Included in 2.5)
> >   G'day,
> >   
> >   
> >   2/5 definitions of CONFIG_BLK_DEV_SR have trivially different banners.
> 
> 2.5 is wrong, 2.4 is right. At least according to Philips who invented
> the things. Please submit the reverse diff to 2.5 8)

<SIGH>
	CDROM seems pretty prevelent in the kernel over CD-ROM.
Unification of the banners is a trivial first step to furthur removal
of things that are gratuitously arch-dependent: this wasn't primarily
a spelling fix.

s/CDROM/CD-ROM/ would probably come under the new "too trivial for
trivial patch monkey rule" in normal circumstances 8)

Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
