From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] zfcp: transport class adaptations II
Date: Fri, 13 Jan 2006 18:12:00 +0000
Message-ID: <20060113181200.GI20718@infradead.org>
References: <20060113012611.GA6048@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:44419 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1422784AbWAMSMC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 13:12:02 -0500
Content-Disposition: inline
In-Reply-To: <20060113012611.GA6048@lion28.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <aherrman@de.ibm.com>
Cc: James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>

On Fri, Jan 13, 2006 at 02:26:11AM +0100, Andreas Herrmann wrote:
> This patch replaces my patch from 2006-01-05
> "zfcp: use fc_host attributes physical_port_name and physical_port_id"
> http://marc.theaimsgroup.com/?l=linux-scsi&m=113645196121540&w=2
> 
> It depends on following patches
> zfcp: handle unsolicited status notification lost
> zfcp: transport class adaptations
> fc transport: add permanent_port_name fc_host attribute
> 
> Please apply.

looks good.  btw, does zfcp now always have rports as parents for
targets so we can remove the special case in fc_target_setup?

