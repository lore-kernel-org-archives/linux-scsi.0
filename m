From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] IBM VSCSI Client: sending client info to  server
Date: Sat, 2 Jul 2005 09:47:19 +1000
Message-ID: <20050701234719.GA5384@krispykreme>
References: <42C0774C.4050006@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:29611 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S261762AbVGBEAf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jul 2005 00:00:35 -0400
Content-Disposition: inline
In-Reply-To: <42C0774C.4050006@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linda Xie <lxiep@us.ibm.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Dave C Boutcher <sleddog@us.ibm.com>, Santiago Leon <santil@us.ibm.com>


Hi,
 
> The attached patch fixes the problem in IBM VSCSI Client where the 
> client doesn't send the information which is expected by the server.

...

> +	printk(KERN_INFO "rpa_vscsi: SPR_VERSION: %s\n", SRP_VERSION);

Just a small thing, should the printk say SRP_VERSION?

Anton
