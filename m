From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: section mismatches (scsi e.g.)
Date: Fri, 14 Apr 2006 12:25:20 -0700
Message-ID: <20060414122520.d1d1a46e.rdunlap@xenotime.net>
References: <20060414092911.71f25ac1.rdunlap@xenotime.net>
	<20060414165210.GA4053@mars.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:4314 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1751423AbWDNTWz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Apr 2006 15:22:55 -0400
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Fri, 14 Apr 2006 12:22:52 -0700
In-Reply-To: <20060414165210.GA4053@mars.ravnborg.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-scsi@vger.kernel.org

On Fri, 14 Apr 2006 18:52:10 +0200 Sam Ravnborg wrote:

> On Fri, Apr 14, 2006 at 09:29:11AM -0700, Randy.Dunlap wrote:
> > Hi Sam,
> > 
> > I was looking at these warnings (on 2.6.17-rc1-git8):
> > 
[snip]

> Darren Jenkins already pointed this pattern out but somehow I lost
> the patch (not applied).
> It is here:

OK, I applied the patch.  Now please consider these (that I doubt):

WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x0)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x8)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x10)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x18)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x20)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x28)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x30)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x38)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x40)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x48)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x50)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x58)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x60)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x68)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x70)
WARNING: drivers/scsi/sd_mod.o - Section mismatch: reference to .exit.text: from .rodata after '' (at offset 0x78)

Any ideas?

---
~Randy
