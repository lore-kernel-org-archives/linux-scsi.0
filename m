From: Tejun Heo <tj@kernel.org>
Subject: Re: Race to power off harming SATA SSDs
Date: Mon, 8 May 2017 15:04:11 -0400
Message-ID: <20170508190411.GB12079@htj.duckdns.org>
References: <1494231215.6528.22.camel@infradead.org>
 <alpine.DEB.2.11.1705081034420.6882@lnxricardw1>
 <1494233673.6528.28.camel@infradead.org>
 <alpine.DEB.2.11.1705081059580.6882@lnxricardw1>
 <7ee84982-cfad-94d7-4e22-4edbeb852b32@redhat.com>
 <1494238390.6528.42.camel@infradead.org>
 <20170508135005.0b9b200b@bbrezillon>
 <20170508164322.GA9781@amd>
 <20170508174303.GA12079@htj.duckdns.org>
 <20170508185615.GA16268@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170508185615.GA16268@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Pavel Machek <pavel@ucw.cz>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>, David Woodhouse <dwmw2@infradead.org>, Hans de Goede <hdegoede@redhat.com>, Ricard Wanderlof <ricard.wanderlof@axis.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-mtd@lists.infradead.org, Henrique de Moraes Holschuh <hmh@hmh.eng.br>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Mon, May 08, 2017 at 08:56:15PM +0200, Pavel Machek wrote:
> Well... the SMART counter tells us that the device was not shut down
> correctly. Do we have reason to believe that it is _not_ telling us
> truth? It is more than one device.

It also finished power off command successfully.

> SSDs die when you power them without warning:
> http://lkcl.net/reports/ssd_analysis.html
> 
> What kind of data would you like to see? "I have been using linux and
> my SSD died"? We have had such reports. "I have killed 10 SSDs in a
> week then I added one second delay, and this SSD survived 6 months"?

Repeating shutdown cycles and showing that the device actually is in
trouble would be great.  It doesn't have to reach full-on device
failure.  Showing some sign of corruption would be enough - increase
in CRC failure counts, bad block counts (a lot of devices report
remaining reserve or lifetime in one way or the other) and so on.
Right now, it might as well be just the SMART counter being funky.

Thanks.

-- 
tejun
