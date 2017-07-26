From: Hannes Reinecke <hare@suse.de>
Subject: Re: [RFC 3/9] zfcp: split FCP_CMND IU setup between SCSI I/O and TMF
 again
Date: Wed, 26 Jul 2017 07:53:15 +0200
Message-ID: <62035be1-c9cb-cb34-653f-3a0149805efc@suse.de>
References: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
 <20170725141427.35258-4-maier@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50090 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750886AbdGZFxS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Jul 2017 01:53:18 -0400
In-Reply-To: <20170725141427.35258-4-maier@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

On 07/25/2017 04:14 PM, Steffen Maier wrote:
> This reverts commit 2443c8b23aea ("[SCSI] zfcp: Merge FCP task management
> setup with regular FCP command setup"), because this introduced a
> dependency on the unsuitable SCSI command for scsi_eh / TMF.
> 
> Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
> ---
>  drivers/s390/scsi/zfcp_fc.h  | 22 ++++++++++++++--------
>  drivers/s390/scsi/zfcp_fsf.c |  4 ++--
>  2 files changed, 16 insertions(+), 10 deletions(-)
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
