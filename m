From: "Anil Veerabhadrappa" <anilgv@broadcom.com>
Subject: Re: [PATCH 3/5] BNX2I - update CQ arming algorith for 5771x
 chipsets
Date: Thu, 10 Dec 2009 10:36:51 -0800
Message-ID: <1260470211.31468.142.camel@anilgv-desktop>
References: <1260214818.31468.98.camel@anilgv-desktop>
 <4B206165.1020803@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1345 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761275AbZLJSgt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Dec 2009 13:36:49 -0500
In-Reply-To: <4B206165.1020803@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, "poswald@novell.com" <poswald@novell.com>

On Wed, 2009-12-09 at 18:48 -0800, Mike Christie wrote:
> Anil Veerabhadrappa wrote:
> >     * Only affects 5771x (10G chipsets) devices
> 
> 
> Why don't you do it on 1 gig? Is it just not worth it or is it no 
> possible due to some limitation?

All NetXtreme2 devices support event coalescing, however the performance
advantage was marginal in 570x (1G) iSCSI offload.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


