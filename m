From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 04/22] atari_NCR5380: Remove DMA_MIN_SIZE macro
Date: Tue, 15 Mar 2016 14:18:41 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1603151418130.20294@nippy.intranet>
References: <20160314042700.596192247@telegraphics.com.au> <20160314042701.626031027@telegraphics.com.au> <56E66781.8000009@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <56E66781.8000009@suse.de>
Sender: linux-m68k-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org


On Mon, 14 Mar 2016, Hannes Reinecke wrote:

> I still would keep the 'DMA_MIN_LEN' definition around for sun3_scsi.c; 
> makes it a bit more obvious what the magic number '129' is supposed to 
> mean.

OK.

-- 
