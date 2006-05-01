From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 0/3] Resend: Handle PQ3 devs better
Date: Sun, 30 Apr 2006 18:04:18 -0700
Message-ID: <1146445479.3671.4.camel@mulgrave>
References: <20060501004457.GC8728@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:37545 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751246AbWEABGK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Apr 2006 21:06:10 -0400
In-Reply-To: <20060501004457.GC8728@tpkurt.garloff.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mansfield <patmans@us.ibm.com>, Andrew Morton <akpm@osdl.org>

On Mon, 2006-05-01 at 02:44 +0200, Kurt Garloff wrote:
> resending the patches ...
> Changes since last posting:
> - I reversed the order of patches 2 and 3, as one patch (now 3)
>   refers to a blacklist flag introduced in the other.
> - Andrew Morton has merged the patches into -mm and fixed up compiler
>   warnings that happened if CONFIG_SCSI_LOGGING was disabled.
>   I merged that into patch 3.
> - The blist flag 0x800000 has been consumed by BLIST_MAX_512, so
>   go for 0x1000000 instead.

OK ... I already did that merger; could you take a look and see what's
in scsi-misc-2.6 and submit patches against that.

Thanks,

James


