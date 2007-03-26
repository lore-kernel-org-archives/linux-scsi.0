From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: some PCMCIA SCSI drivers can be built *only* as modules
Date: Mon, 26 Mar 2007 15:27:54 +0200
Message-ID: <4607CA5A.4040906@s5r6.in-berlin.de>
References: <Pine.LNX.4.64.0703250916090.22484@CPE00045a9c397f-CM001225dbafb6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752316AbXCZN2F@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703250916090.22484@CPE00045a9c397f-CM001225dbafb6>
Sender: linux-kernel-owner@vger.kernel.org
To: "Robert P. J. Day" <rpjday@mindspring.com>, linux-scsi@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Robert P. J. Day wrote at LKML:
> drivers/scsi/pcmcia/Kconfig:
> ...
> config PCMCIA_AHA152X
>         tristate "Adaptec AHA152X PCMCIA support"
>         depends on m && !64BIT
>         select SCSI_SPI_ATTRS
>         help
>           Say Y here if you intend to attach this type of PCMCIA SCSI host
>           adapter to your computer.
> 
>           To compile this driver as a module, choose M here: the
>           module will be called aha152x_cs.
> ...
> 
>   it would seem to make no sense that the "depends on" clause for this
> option includes "m", forcing this (and all other four entries in that
> Kconfig file, by the way) to be built as modules, while the help text
> for all five entries suggests you can select "y".
> 
>   as jack nicholson would say, something's gotta give.

LSML a.k.a. linux-scsi may know what's gotta give.
-- 
Stefan Richter
-=====-=-=== --== ==-=-
http://arcgraph.de/sr/
