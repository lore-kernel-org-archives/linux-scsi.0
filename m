From: Borislav Petkov <bp@alien8.de>
Subject: Section mismatch in reference from the function
 generic_NCR5380_isa_match()
Date: Sat, 29 Oct 2016 12:12:21 +0200
Message-ID: <20161029101221.i3elrkrshtnrtddd@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

I'm seeing this during randconfig builds:

WARNING: vmlinux.o(.text+0x1588439): Section mismatch in reference from the function generic_NCR5380_isa_match() to the function .init.text:probe_intr()
The function generic_NCR5380_isa_match() references
the function __init probe_intr().
This is often because generic_NCR5380_isa_match lacks a __init 
annotation or the annotation of probe_intr is wrong.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
