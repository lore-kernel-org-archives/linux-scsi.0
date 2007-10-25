From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [2.6 patch] 53c7xx removal fallout
Date: Thu, 25 Oct 2007 22:19:57 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710252219470.12012@anakin>
References: <20071024162622.GI30533@stusta.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762906AbXJYUVg@vger.kernel.org>
In-Reply-To: <20071024162622.GI30533@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@SteelEye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 24 Oct 2007, Adrian Bunk wrote:
> This patch does some additional cleanups after the 53c7xx removal.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
> 
>  Documentation/dontdiff                |    2 
>  Documentation/m68k/kernel-options.txt |   60 --------------------------
>  Documentation/scsi/00-INDEX           |    2 
>  Documentation/scsi/ncr53c7xx.txt      |   40 -----------------
>  drivers/scsi/.gitignore               |    2 
>  5 files changed, 106 deletions(-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
