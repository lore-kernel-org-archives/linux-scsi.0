From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi_tcp: add write permission to max_lun
Date: Wed, 15 Aug 2012 10:50:52 -0500
Message-ID: <DECF1C60-0ED2-4652-BD0D-5BA4F23F5D21@cs.wisc.edu>
References: <1345030205-23393-1-git-send-email-revers@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:57333 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228Ab2HOPvE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Aug 2012 11:51:04 -0400
In-Reply-To: <1345030205-23393-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org


On Aug 15, 2012, at 6:30 AM, Rob Evers <revers@redhat.com> wrote:

> Add root write permission to iscsi_tcp max_lun parameter
> 
> Signed-off-by: Rob Evers <revers@redhat.com>
> ---
> drivers/scsi/iscsi_tcp.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 9220861..e8609a4 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -56,7 +56,7 @@ static struct scsi_host_template iscsi_sw_tcp_sht;
> static struct iscsi_transport iscsi_sw_tcp_transport;
> 
> static unsigned int iscsi_max_lun = 512;
> -module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
> +module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO|S_IWUSR);



Looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
