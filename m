From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH 6/10][RFC] linux-iscsi driver
Date: Wed, 12 Jan 2005 14:41:56 -0800
Message-ID: <1105569717.21043.3.camel@markh1.pdx.osdl.net>
References: <41E30958.5060309@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fire.osdl.org ([65.172.181.4]:15314 "EHLO fire-1.osdl.org")
	by vger.kernel.org with ESMTP id S261522AbVALWmF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2005 17:42:05 -0500
In-Reply-To: <41E30958.5060309@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2005-01-10 at 15:01 -0800, Mike Christie wrote:
> The attached patch implememts the IO functions for
> the driver. They are built upon the network
> subsystem's socket functions, so any ideas about
> how to handle OOM situations when using that
> layer would be greatly appreciated.

I get:

  BUILD   arch/i386/boot/bzImage
Root device is (3, 3)
Boot sector 512 bytes.
Setup is 5215 bytes.
System is 2530 kB
Kernel: arch/i386/boot/bzImage is ready
  Building modules, stage 2.
  MODPOST
*** Warning: "__scsi_print_sense" [drivers/scsi/iscsi-sfnet/iscsi_sfnet.ko] undefined!


when building the iscsi module in the latest kernel BK view.


-- 
Mark Haverkamp <markh@osdl.org>

