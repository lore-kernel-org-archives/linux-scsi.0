From: Bernd Schubert <bernd-schubert@gmx.de>
Subject: Re: a couple of oopses with 2.6.14
Date: Fri, 10 Feb 2006 01:32:11 +0100
Message-ID: <200602100132.12120.bernd-schubert@gmx.de>
References: <200602091934.20732.bernd.schubert@pci.uni-heidelberg.de> <20060209152744.00de43f6.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.21]:21211 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1750870AbWBJAcP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Feb 2006 19:32:15 -0500
In-Reply-To: <20060209152744.00de43f6.akpm@osdl.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Hello Andrew and James,

thanks for your help.


On Friday 10 February 2006 00:27, Andrew Morton wrote:
> Bernd Schubert <bernd.schubert@pci.uni-heidelberg.de> wrote:
> > Hi,
> >
> > here's a machine that works perfectly with 2.6.11, but gives oopes =
during
> > the boot process with 2.6.14. Unfortunately its everytime another o=
ops.
> > Usually I would assume its a memory issue, but the machine really w=
orks
> > perfectly with 2.6.11.
>
> scsi has had a few problems with error recovery lately.
>
> > We will run a memory test over the weekend, but so far I don't beli=
eve it
> > will find anything.
>
> No, I wouldn't bother doing that.

Ok.

>
> > ------------- example 1
> > ------------------------------------------------------
> >
> > [4294676.669000] scsi0 : ata_piix
> > [4294676.831000] ATA: abnormal status 0x7F on port 0xE407
>
> So we have a sata problem.  It triggered two scsi bugs.  The first (a
> warning) is being fixed.  I don't know if the second has been fixed.

I'm not sure if its only a sata problem, I saw several of other oopses,=
 one=20
was related to Firewire/scsi (ok, could be a consequence of the previou=
s sata=20
problem), one came from bluesmoke (external patch) and some of them I=20
couldn't associate to anything (but those I couldn't also capture via=20
netconsole).


>
> Can you test 2.6.15?
>

Sure, I will test 2.6.15 this evening. I will also enable most debuggin=
g=20
information for this testkernel, ok?


Thanks,
	Bernd


PS: For production we unfortunately can't use 2.6.15 - reiserfs trouble=
 (well,=20
I could try to revert commit 5fa8ad644faa114c4190484ac50e15236fc7cdd9, =
but=20
I'm still waiting for an offical statement of the reiserfs poeple) and=20
Win4Lin patches are available up to 2.6.14 only (its the PC of our secr=
etary=20
and she really wouldn't like that ;) ).

--=20
Bernd Schubert
PCI / Theoretische Chemie
Universit=E4t Heidelberg
INF 229
69120 Heidelberg

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
