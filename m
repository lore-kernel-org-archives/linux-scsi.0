From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/4] scsi: remove tsk_mgmt_response and it_nexus_response
 transport methods
Date: Mon, 30 Jan 2017 16:31:06 +0100
Message-ID: <dc34b7fc-eb5a-bdb6-5d90-a1189cb5667c@suse.de>
References: <1485778739-29036-1-git-send-email-hch@lst.de>
 <1485778739-29036-5-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41789 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753659AbdA3PbJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Jan 2017 10:31:09 -0500
In-Reply-To: <1485778739-29036-5-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 01/30/2017 01:18 PM, Christoph Hellwig wrote:
> They are never called and just dispatch to methods of the same names in
> the FC and SRP transport classes that are never implemented.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/scsi/scsi_transport_fc.c  | 17 -----------------
>  drivers/scsi/scsi_transport_srp.c | 16 ----------------
>  include/scsi/scsi_transport.h     | 12 ------------
>  include/scsi/scsi_transport_srp.h |  7 -------
>  4 files changed, 52 deletions(-)
> 
These are actually left-overs from the original target mode
implementation from Tomo.
So yes, they can go now.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
