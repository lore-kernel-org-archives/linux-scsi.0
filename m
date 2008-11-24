From: David Miller <davem@davemloft.net>
Subject: Re: Conversion of old Amiga NCR53C9x drivers to esp_scsi
Date: Mon, 24 Nov 2008 13:50:26 -0800 (PST)
Message-ID: <20081124.135026.241886343.davem@davemloft.net>
References: <1227560510.15190.18.camel@kars.perseus.home>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <1227560510.15190.18.camel@kars.perseus.home>
Sender: linux-m68k-owner@vger.kernel.org
To: jongk@linux-m68k.org
Cc: linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Kars de Jong <jongk@linux-m68k.org>
Date: Mon, 24 Nov 2008 22:01:50 +0100

> What is the way to go? Revive the glue named drivers/scsi/blz1230.c?
> Or should it be renamed?
> 
> Some of the other drivers may be a little more problematic because they
> had more driver operations which are not present in the esp_scsi DMA
> abstraction.

Whatever tweaks you need to make to the DMA abstraction to make
your parts work are probably fine.  Get your hardware working
and then post your esp_scsi core changes for review here.
