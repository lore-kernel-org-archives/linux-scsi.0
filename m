From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Subject: Re: [PATCH 2/2] drivers/scsi/sun3x_esp.c: Convert && to ||
Date: Tue, 14 Oct 2008 18:30:07 +0200
Message-ID: <20081014163007.GA9015@alpha.franken.de>
References: <Pine.LNX.4.64.0810141759520.20451@pc-004.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753776AbYJNQae@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810141759520.20451@pc-004.diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, sammy@sammy.net, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 14, 2008 at 06:00:19PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The pattern !E && !E->fld is nonsensical.  The patch below updates this
> according to the assumption that && should be ||.  But perhaps another
> solution was intended.

Acked-By: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Thanks for fixing this.
Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
