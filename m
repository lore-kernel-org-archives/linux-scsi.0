From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] dpt_i2o: convert to SCSI hotplug model
Date: Mon, 30 Jul 2007 17:47:07 -0400
Message-ID: <46AE5C5B.7020106@garzik.org>
References: <20070730211917.GK21219@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:60999 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966453AbXG3VrZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jul 2007 17:47:25 -0400
In-Reply-To: <20070730211917.GK21219@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: aacraid@adaptec.com, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> dpt_i2o: Convert to new SCSI driver model
> 
>  - Delete refereces to HOSTS_C
>  - Switch to module_init/module_exit instead of detect/release
>  - Don't pass around the host template and rename it to adpt_template
>  - Switch from scsi_register/scsi_unregister to scsi_host_alloc,
>    scsi_add_host, scsi_scan_host and scsi_host_put.

ACK.

I like the minimal nature of this patch.  I hope that any unrelated 
cleanups go into separate patches, following this one.

