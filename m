From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] zfcp: initialize scsi_host_template.max_sectors with
	appropriate value
Date: Wed, 11 Oct 2006 10:05:21 -0500
Message-ID: <1160579121.3447.21.camel@mulgrave.il.steeleye.com>
References: <200610091533.42282.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:59614 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965224AbWJKPF1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Oct 2006 11:05:27 -0400
In-Reply-To: <200610091533.42282.swen@vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Swen Schillig <swen@vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2006-10-09 at 15:33 +0200, Swen Schillig wrote:
> commit 7f3c3e955cfba57c4d95706c326d9c5b2f92e941
> Author: Swen Schillig <swen@vnet.ibm.com>
> Date:   Mon Oct 9 14:59:08 2006 +0200
> 
> Define (ZFCP_MAX_SECTORS) and initialize scsi_host_template.max_sectors with 
> appropriate value.
> 
>      ZFCP_MAX_SECTORS (ZFCP_MAX_SBALES_PER_REQ * 8)
>         /* max. number of (data buffer) SBALEs in largest SBAL chain
>            multiplied with number of sectors per 4k block */

This needs a signoff.

Plus it doesn't apply: it looks like your mailer has converted tabs to
spaces.

James


