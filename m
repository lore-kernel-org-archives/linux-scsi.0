From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 2/3] Better log messages for PQ3 devs
Date: Wed, 29 Mar 2006 16:23:04 -0600
Message-ID: <1143670984.3248.66.camel@mulgrave.il.steeleye.com>
References: <20060329201020.GG7919@tpkurt.suse.de>
	 <20060329201247.GI7919@tpkurt.suse.de>
	 <20060329203009.GC13590@parisc-linux.org>
	 <20060329221248.GK7919@tpkurt.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:40143 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750812AbWC2WXU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 17:23:20 -0500
In-Reply-To: <20060329221248.GK7919@tpkurt.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mansfield <patmans@us.ibm.com>

On Thu, 2006-03-30 at 00:12 +0200, Kurt Garloff wrote:
> Indeed, my terminals are all more than 80 chars wide these days :-)
> If that's the only concern, I'm happy to address it.

Actually, if you're going to re-roll, please use the sdev_printk() macro
instead of printk on the device bus_id.

James


