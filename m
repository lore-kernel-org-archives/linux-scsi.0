From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: [BUG 2.6.17-git] kmem_cache_create: duplicate cache scsi_cmd_cache
Date: Fri, 12 May 2006 12:09:50 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0605121209020.3866@g5.osdl.org>
References: <20060511151456.GD3755@harddisk-recovery.com>
 <15ddcffd0605112153q57f139a1k7068e204a3eeaf1f@mail.gmail.com>
 <20060512171632.GA29077@harddisk-recovery.com>  <Pine.LNX.4.64.0605121024310.3866@g5.osdl.org>
  <1147456038.3769.39.camel@mulgrave.il.steeleye.com>
 <1147460325.3769.46.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:52377 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751349AbWELTKQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 15:10:16 -0400
In-Reply-To: <1147460325.3769.46.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Erik Mouw <erik@harddisk-recovery.com>, Or Gerlitz <or.gerlitz@gmail.com>, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk, axboe@suse.de, Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>



On Fri, 12 May 2006, James Bottomley wrote:
> 
> I suggest simply reversing this patch at the moment.  If Russell and
> Jens can tell me what they're trying to do I'll see if there's another
> way to do it.

Reverted, with a big changelog entry to explain why. 

		Linus
