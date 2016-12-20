From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 06/11] lpfc: FCoE VPort enable-disable does not bring
 up the VPort
Date: Tue, 20 Dec 2016 14:37:46 +0100
Message-ID: <97926321-2ae7-5e09-1b49-00d388d526e8@suse.de>
References: <5858682d.aQM+tiYMeD1WO87L%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33137 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932415AbcLTNhv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Dec 2016 08:37:51 -0500
In-Reply-To: <5858682d.aQM+tiYMeD1WO87L%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, linux-scsi@vger.kernel.org

On 12/20/2016 12:07 AM, James Smart wrote:
> 
> FCoE VPort enable-disable does not bring up the VPort.
> VPI structure needed to be initialized before being re-registered.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc_vport.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
