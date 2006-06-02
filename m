From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 20/25] random: remove redundant SA_SAMPLE_RANDOM from NinjaSCSI
Date: Fri, 2 Jun 2006 03:28:59 -0400
Message-ID: <20060602072859.GE32507@havoc.gtf.org>
References: <200606020338.k523cQ4t029264@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:61419 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751251AbWFBH3G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2006 03:29:06 -0400
Content-Disposition: inline
In-Reply-To: <200606020338.k523cQ4t029264@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, mpm@selenic.com

On Thu, Jun 01, 2006 at 08:42:45PM -0700, akpm@osdl.org wrote:
> 
> From: Matt Mackall <mpm@selenic.com>
> 
> The scsi layer is already calling add_disk_randomness in scsi_end_request.
> 
> ps: ninjas rule!

If there was ever any question of that...  http://askaninja.com/

	Jeff



