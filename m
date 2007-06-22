From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH] dtc: Coding police and printk levels
Date: Fri, 22 Jun 2007 11:00:06 -0700
Message-ID: <20070622180005.GF7535@tree.beaverton.ibm.com>
References: <20070622142629.52519e47@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42740 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752933AbXFVR6Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jun 2007 13:58:25 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5MHwO10002961
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jun 2007 13:58:24 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5MHwOPA490360
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jun 2007 13:58:24 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5MHwOC9009716
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jun 2007 13:58:24 -0400
Content-Disposition: inline
In-Reply-To: <20070622142629.52519e47@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

On Fri, Jun 22, 2007 at 02:26:29PM +0100, Alan Cox wrote:
> @@ -244,7 +242,7 @@
>  					if (check_signature(base + signatures[sig].offset, signatures[sig].string, strlen(signatures[sig].string))) {
>  						addr = bases[current_base].address;
>  #if (DTCDEBUG & DTCDEBUG_INIT)
> -						printk("scsi-dtc : detected board.\n");
> +						printk(KERB_DEBUG "scsi-dtc : detected board.\n");

I think you meant KERN_DEBUG ?

--D
