From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for December 27 (drivers/target/)
Date: Mon, 27 Dec 2010 11:21:14 -0800
Message-ID: <20101227112114.634c6e60.randy.dunlap@oracle.com>
References: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:46928 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985Ab0L0TXt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Dec 2010 14:23:49 -0500
In-Reply-To: <20101227170451.a9a9f873.sfr@canb.auug.org.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, nab@kernel.org

On Mon, 27 Dec 2010 17:04:51 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> [The mirroring on kernel.org is running slowly]

yep :(

> Changes since 20101221:


When CONFIG_SCSI is not enabled:

ERROR: "scsi_device_type" [drivers/target/target_core_mod.ko] undefined!

from target_core_transport.c::1586:

	printk("  Type:   %s ", scsi_device_type(device_type));


Also please update MAINTAINERS for drivers/target/.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
desserts:  http://www.xenotime.net/linux/recipes/
