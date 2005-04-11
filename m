From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] compile out scsi_ioctl when no SCSI/IDE/etc. (take 3)
Date: Mon, 11 Apr 2005 12:03:11 -0700
Message-ID: <20050411190311.GT3174@waste.org>
References: <1CFEB358338412458B21FAA0D78FE86D4F0D3B@rennsmail02.eu.thmulti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from waste.org ([216.27.176.166]:18893 "EHLO waste.org")
	by vger.kernel.org with ESMTP id S261879AbVDKTDU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Apr 2005 15:03:20 -0400
Content-Disposition: inline
In-Reply-To: <1CFEB358338412458B21FAA0D78FE86D4F0D3B@rennsmail02.eu.thmulti.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fillod Stephane <stephane.fillod@thomson.net>
Cc: linux-tiny@selenic.com, linux-scsi@vger.kernel.org

On Mon, Apr 11, 2005 at 05:50:08PM +0200, Fillod Stephane wrote:
> Hi Matt and everyone, 
> 
> I fixed again my previous patch (take2):
> 
> * CDROM_PKTCDVD draws dependency
> 
> * removing SCSI_IOCTL from displayed options,
>   as suggested by Milton Miller.
> 
> * rewrote ifdefs in the middle of ide.c functions as dummy function 
>   in header, as suggested by Matthew Wilcox.
> 
> 
> Matt, how do we proceed from here? If the patch is to your liking,
> can I hand it off to you, for eventual submission to Linus
> or the SCSI team?

Since this is already cc:ed to linux-scsi, hopefully they'll pick it
up. But this current version looks good to me.

-- 
Mathematics is the supreme nostalgia of our time.
