From: Marcelo Tosatti <marcelo@conectiva.com.br>
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Sat, 28 Dec 2002 03:32:44 -0200 (BRST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.50L.0212280331110.30646-100000@freak.distro.conectiva>
References: <200212210012.gBL0Cng21338@eng2.beaverton.ibm.com>
 <176730000.1040430221@aslan.btc.adaptec.com> <3E03BB0D.5070605@rackable.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from burns.conectiva (burns.conectiva [10.0.0.4])
	by perninha.conectiva.com.br (Postfix) with SMTP id 3B842475D9
	for <linux-scsi@vger.kernel.org>; Sat, 28 Dec 2002 06:32:46 -0200 (BRST)
In-Reply-To: <3E03BB0D.5070605@rackable.com>
List-Id: linux-scsi@vger.kernel.org
To: Samuel Flory <sflory@rackable.com>
Cc: "Justin T. Gibbs" <gibbs@scsiguy.com>, Janet Morgan <janetmor@us.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>


On Fri, 20 Dec 2002, Samuel Flory wrote:

> Justin T. Gibbs wrote:
>
> >>I have an Adaptec AIC-7897 Ultra2 SCSI adapter on a system with 8G
> >>of physical memory.  The adapter is using bounce buffers when DMA'ing
> >>to memory >4G because of a bug in the aic7xxx driver.
> >>
> >>
> >
> >This has been fixed in both the aic7xxx and aic79xx drivers for some
> >time.  The problem is that these later revisions have not been integrated
> >into the mainline trees.
> >
> >
> >
>   Marcelo, what is required get the aic79xx driver, and the aic7xxx
> updates into 2.4.21?  A number of linux distros are already using it.
>  It would really help people using board with the U320.
>
>     I've been using both drivers for some time with no issues.  Or maybe
> you'd prefer Alan put it in his tree 1st?

Ho, hum, I prefer getting it tested in -ac for a while first.
