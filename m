From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [RFC PATCH 74/71] ncr5380: Enable PDMA for NCR53C400A
Date: Mon, 30 Nov 2015 23:04:16 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1511302255470.17483@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <1448789980-30094-2-git-send-email-linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448789980-30094-2-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Sun, 29 Nov 2015, Ondrej Zary wrote:

> Add I/O register mapping for NCR53C400A and enable PDMA mode to
> improve performance and fix non-working IRQ.
> 

Is CONFIG_SCSI_GENERIC_NCR53C400 is still needed? Can the driver be fully 
configured at runtime now?

> Tested with HP C2502 (and user-space enabler).
> 

It would be nice if the enabler was documented.  
Documentation/scsi/g_NCR5380.txt might be a good place for that. That file 
could perhaps be updated (?) Certainly obsolete and misleading information 
should be removed if you see any.

-- 
