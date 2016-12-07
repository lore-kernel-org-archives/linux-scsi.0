From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 22/22] qla2xxx: Add check for corrupt ATIO.
Date: Wed, 7 Dec 2016 13:25:53 +0100
Message-ID: <ea1f9124-826a-5d43-20f7-8fd51b22edb9@suse.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
 <1481056251-2310-23-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:40734 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752156AbcLGM0C (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Wed, 7 Dec 2016 07:26:02 -0500
In-Reply-To: <1481056251-2310-23-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@cavium.com>, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org

On 12/06/2016 09:30 PM, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@cavium.com>
> 
> corrupt ATIO is defined as length of fcp_header & fcp_cmd
> payload is less than 0x38. It's the minimum size for a frame to
> carry 8..16 bytes SCSI CDB. The exchange will be drop or
> terminated if corrupted
> 
> Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
> Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
> ---
>  drivers/scsi/qla2xxx/qla_def.h    |  3 ++-
>  drivers/scsi/qla2xxx/qla_target.c | 23 ++++++++++++++++++++---
>  drivers/scsi/qla2xxx/qla_target.h | 16 +++++++++++++++-
>  3 files changed, 37 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
