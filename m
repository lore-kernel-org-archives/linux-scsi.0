From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sd: Reshuffle init_sd to avoid crash
Date: Wed, 10 Oct 2012 10:55:41 +0100
Message-ID: <1349862941.2452.11.camel@dabdike.int.hansenpartnership.com>
References: <1349858171-29358-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60815 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688Ab2JJJzo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Oct 2012 05:55:44 -0400
In-Reply-To: <1349858171-29358-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, "Joel D. Diaz" <joeldiaz@us.ibm.com>

On Wed, 2012-10-10 at 10:36 +0200, Hannes Reinecke wrote:
> scsi_register_driver will register a prep_fn() function, which
> in turn migh need to use the sd_cdp_pool for DIF.
> Which hasn't been initialised at this point, leading to
> a crash. So reshuffle the init_sd() and exit_sd() paths
> to have the driver registered last.
> 
> Signed-off-by: Joel D. Diaz <joeldiaz@us.ibm.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Explain what these signoffs mean, since the patch is sent with you as
the author.

Thanks,

James


