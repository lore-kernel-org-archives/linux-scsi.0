From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 2/5] qla2xxx: Fix mailbox command timeout due to
 starvation
Date: Thu, 1 Dec 2016 08:58:01 +0100
Message-ID: <edb6a523-beb0-04df-8dfc-18d7b1a77ff6@suse.de>
References: <1480537497-16429-1-git-send-email-himanshu.madhani@cavium.com>
 <1480537497-16429-3-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34764 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755709AbcLAH6I (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Dec 2016 02:58:08 -0500
In-Reply-To: <1480537497-16429-3-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On 11/30/2016 09:24 PM, Himanshu Madhani wrote:
> From: Samy <samy@purestorage.com>
> 
> Signed-off-by: Samy <samy@purestorage.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_def.h |  3 ++
>  drivers/scsi/qla2xxx/qla_mbx.c | 88 ++++++++++++++++++++++++++++++------------
>  drivers/scsi/qla2xxx/qla_os.c  | 24 ++++++++++++
>  3 files changed, 91 insertions(+), 24 deletions(-)
> 
This could do with a some description.

Otherwise:

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
