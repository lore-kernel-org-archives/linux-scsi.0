From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/22] fcoe: FIP debugging
Date: Thu, 4 Aug 2016 08:07:58 +0200
Message-ID: <caca3a91-69ad-7e95-8b12-f9fe2bcf09ff@suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
 <1470230002-37737-4-git-send-email-hare@suse.de>
 <cbf099ce-5b8d-7426-52c2-a7882105eb80@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49404 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbcHDGJU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2016 02:09:20 -0400
In-Reply-To: <cbf099ce-5b8d-7426-52c2-a7882105eb80@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.com>

On 08/03/2016 07:36 PM, Bart Van Assche wrote:
> On 08/03/2016 06:13 AM, Hannes Reinecke wrote:
>> @@ -2407,15 +2411,21 @@ static void fcoe_ctlr_vn_probe_req(struct
>> fcoe_ctlr *fip,
>>           */
>>          if (fip->lp->wwpn > rdata->ids.port_name &&
>>              !(frport->flags & FIP_FL_REC_OR_P2P)) {
>> +            LIBFCOE_FIP_DBG(fip, "vn_probe_req: "
>> +                    "port_id collision\n");
>>              fcoe_ctlr_vn_send(fip, FIP_SC_VN_PROBE_REP,
>>                        frport->enode_mac, 0);
> 
> Some users search through the kernel source tree for error and debug
> messages. For these users it is easier if the entire message occurs on a
> single line. Otherwise this patch looks fine to me.
> 
Multiline logging messages; I know.
I have the constant urge to fold everything on 80 chars.
And even checkpatch seems to be unsure whether logging messages
extending beyond 80 chars should be allowed or not.
But okay, one line it is.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
