From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [TRIVIAL] Re: Remove modules.txt drivers_scsi_pcmcia_Kconfig
Date: Thu, 11 Sep 2003 08:08:53 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030911080853.41949176.rddunlap@osdl.org>
References: <20030911064500.349942C4C0@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:2239 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261364AbTIKPOq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2003 11:14:46 -0400
In-Reply-To: <20030911064500.349942C4C0@lists.samba.org>
List-Id: linux-scsi@vger.kernel.org
To: Rusty Trivial Russell <trivial@rustcorp.com.au>
Cc: torvalds@osdl.org, linux-scsi@vger.kernel.org, axboe@suse.de

On Thu, 11 Sep 2003 16:40:01 +1000 Rusty Trivial Russell <trivial@rustcorp.com.au> wrote:

| From:  Nicolas Kaiser <nikai@nikai.net>
| 
|   Cheers, n.
| 
| -	  This driver is also available as a module called aha152x_cs ( =
| -	  code which can be inserted in and removed from the running kernel
| -	  whenever you want). If you want to compile it as a module, say M
| -	  here and read <file:Documentation/modules.txt>.
| +	  To compile this driver as a module, say M here: the
| +	  module will be called aha152x_cs.

This is trivial, but I would prefer to see   "select M here:"
instead of "say M here:" in all of these.

--
~Randy
