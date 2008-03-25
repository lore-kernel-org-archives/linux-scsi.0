From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 3/8] Rename 'state' attribute in lpfc and qla2xxx
Date: Mon, 24 Mar 2008 20:53:20 -0700
Message-ID: <20080325035320.GB21434@plap4.local>
References: <20080318133228.61EE225918@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:36031 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899AbYCYDx1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Mar 2008 23:53:27 -0400
Content-Disposition: inline
In-Reply-To: <20080318133228.61EE225918@pentland.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Tue, 18 Mar 2008, Hannes Reinecke wrote:

> lpfc and qla2xxx overwrite the standard 'state' attribute with
> custom callbacks. So rename the custom attributes to 'link_state'
> and retain the original meaning of the 'state' attribute.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
