From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] mptsas: eliminate ghost devices
Date: Fri, 30 Jun 2006 16:25:26 -0500
Message-ID: <1151702726.8921.48.camel@mulgrave.il.steeleye.com>
References: <20060630210720.GA10260@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:28333 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932564AbWF3VZk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jun 2006 17:25:40 -0400
In-Reply-To: <20060630210720.GA10260@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2006-06-30 at 15:07 -0600, Eric Moore wrote:
> +               if (scsi_is_host_device(parent)) {
> +                       if (!identify.target_port_protocols &&
> +                               (identify.device_type ==
> SAS_END_DEVICE))
> +                               goto out;

Won't this happen for any initiator, rather than just the parent (i.e.
in a multi-initiator environment we won't see anything even for remote
initiators)?

James


