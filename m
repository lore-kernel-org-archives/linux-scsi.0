From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/3] BNX2I: Bug fixes and Performance Optimization
Date: Wed, 18 May 2011 14:52:54 -0500
Message-ID: <4DD42396.6000702@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1305569600-1523-1-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41035 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941Ab1ERTw0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 15:52:26 -0400
In-Reply-To: <1305569600-1523-1-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 05/16/2011 01:13 PM, Eddie Wai wrote:
> Hello,
>
> This patch set contains a bug fix and some performance optimization
> for iSCSI offload connection cleanup/recovery and throughput.
>
> Please review, thanks.
>
> Eddie Wai (3):
>    BNX2I: Fixed packet error created when the sq_size is set to 16
>    BNX2I: Updated the connection shutdown/cleanup timeout
>    BNX2I: Optimized the iSCSI offload performance
>
>   drivers/scsi/bnx2i/bnx2i.h       |   16 ++++++++++------
>   drivers/scsi/bnx2i/bnx2i_hwi.c   |   27 +++++++++++++++------------
>   drivers/scsi/bnx2i/bnx2i_init.c  |    2 +-
>   drivers/scsi/bnx2i/bnx2i_iscsi.c |   13 +++++++++++--
>   4 files changed, 37 insertions(+), 21 deletions(-)
>

Got my question in the other mail answered.

Patches look ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
