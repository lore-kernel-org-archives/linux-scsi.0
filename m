From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: Section mismatch in reference from the function
 generic_NCR5380_isa_match()
Date: Sat, 29 Oct 2016 10:34:21 -0600
Message-ID: <20161029163420.2lheb5xzqb3ovqmc@linux-x5ow.site>
References: <20161029101221.i3elrkrshtnrtddd@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161029101221.i3elrkrshtnrtddd@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Ondrej Zary <linux@rainbow-software.org>, Finn Thain <fthain@telegraphics.com.au>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Oct 29, 2016 at 12:12:21PM +0200, Borislav Petkov wrote:
> Hi,
> 
> I'm seeing this during randconfig builds:
> 
> WARNING: vmlinux.o(.text+0x1588439): Section mismatch in reference from the function generic_NCR5380_isa_match() to the function .init.text:probe_intr()
> The function generic_NCR5380_isa_match() references
> the function __init probe_intr().
> This is often because generic_NCR5380_isa_match lacks a __init 
> annotation or the annotation of probe_intr is wrong.

There's already a fix for it from Arnd [1] which should be in Linus' tree
already.


[1] 77f18a871 ("scsi: NCR5380: no longer mark irq probing as __init")

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
