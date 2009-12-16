From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Applying MVSAS Patch
Date: Wed, 16 Dec 2009 08:13:01 -0800
Message-ID: <20091216081301.59d1698e.randy.dunlap@oracle.com>
References: <67980649284293627495293095942659870934-Webmail@me.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:34646 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbZLPQNI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2009 11:13:08 -0500
In-Reply-To: <67980649284293627495293095942659870934-Webmail@me.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Tehonica <matt.tehonica@mac.com>
Cc: linux-scsi@vger.kernel.org, ayan@marvell.com

On Wed, 16 Dec 2009 09:22:40 -0500 Matthew Tehonica wrote:

> Hi All,
> 
> I am trying to apply the first patch to fix the mvsas issue and getting an error that I can't figure out. See below:
> 
> mtehonica@ghostrider:/usr/src/linux-2.6.32$ sudo patch -p1 < /home/mtehonica/Downloads/0001-Update-chip-init-code-to-enhance-performance.patch 
> patching file drivers/scsi/mvsas/mv_64xx.c
> patch: **** malformed patch at line 65:  	/* interrupt coalescing may cause missing HW interrput in some case,
> 
> I have played around with removing the line that it complains about and it just then says the next line is malformed.  Can anyone help with this???


It would help if you pointed us at the specific patch that you are
referring to.

malformed patch (to me) usually means that some (long-ish) lines were
split by a mail app or mail server and those lines need to be joined
together.  That's the reason that I see most often, although I expect
that there could be other reasons for it.


---
~Randy
