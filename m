From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v7 0/6] g_NCR5380: PDMA fixes and cleanup
Date: Wed, 5 Jul 2017 10:40:37 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1707051040280.2194@nippy.intranet>
References: <cover.1499067144.git.fthain@telegraphics.com.au> <201707042254.20791.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201707042254.20791.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 4 Jul 2017, Ondrej Zary wrote:

> 
> Everything works fine! No corruption, no hangs, rescan-scsi-bus works.
> 
> Tested cards:
> Canon FG2-5202 (53C400 chip, MMIO)
> DTC-3181L (DTCT-436P chip, PIO)
> HP C2502 (53C400A chip, PIO)
> 
> Tested devices:
> QUANTUM  LP240S GM240S01X 4.6
> IBM      DORS-32160       WA0A
> SONY     CD-ROM CDU-415   1.1g
> SONY     CD-ROM CDU-55S   1.0t
> 
> Tested-by: Ondrej Zary <linux@rainbow-software.org>
> 

Great! Thanks for testing all of those revisions.

-- 
