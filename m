From: Borislav Petkov <bp@amd64.org>
Subject: Re: Linux kernel crash (3.2.0-2-amd64) when trying to play audio CD
Date: Mon, 18 Jun 2012 17:51:41 +0200
Message-ID: <20120618155141.GF8378@aftab.osrc.amd.com>
References: <87obojef7t.fsf@schwinge.name>
 <20120616181008.GB20623@liondog.tnic>
 <87ehpddw9k.fsf@schwinge.name>
 <20120618142900.GA9710@aftab.osrc.amd.com>
 <87sjdsd64r.fsf@schwinge.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87sjdsd64r.fsf@schwinge.name>
Sender: linux-ide-owner@vger.kernel.org
To: Thomas Schwinge <thomas@codesourcery.com>
Cc: Borislav Petkov <bp@amd64.org>, Borislav Petkov <bp@alien8.de>, debian-kernel@lists.debian.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 18, 2012 at 04:52:36PM +0200, Thomas Schwinge wrote:
> Hi Borislav!
> 
> First, thanks for helping!

Sure, np! :-)

> > Ok, can you do the following:
> > 
> > $ setpci -s 18.0 0x68.l
> 
>     $ sudo setpci -s 18.0 0x68.l
>     0f00cc0f
> 
> > $ rdmsr 0xc001001f
> 
>     $ sudo modprobe msr
>     $ sudo rdmsr 0xc001001f
>     8

Ok, this is a BIOS bug - we have a recommendation about what the BIOS
should do but yours doesn't do it. Are you sure you're using the latest
BIOS for your motherboard?

Can you check for updates and if you get a newer version, can you update
your BIOS and do the two commands above?

If there's no newer BIOS, we can try applying the workaround at boot in
an init script to fix your issue.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
