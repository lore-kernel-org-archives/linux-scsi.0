From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] increase iscsi_tcp max_lun to ~0, don't care
Date: Wed, 15 Aug 2012 23:33:01 -0500
Message-ID: <373C69D7-6A64-49FE-A5EA-5B281382EA27@cs.wisc.edu>
References: <1345070374-32058-1-git-send-email-revers@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58599 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab2HPEdK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Aug 2012 00:33:10 -0400
In-Reply-To: <1345070374-32058-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org


On Aug 15, 2012, at 5:39 PM, Rob Evers <revers@redhat.com> wrote:

> 
> Signed-off-by: Rob Evers <revers@redhat.com>
> ---
> drivers/scsi/iscsi_tcp.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 9220861..1b91ca0 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -55,7 +55,7 @@ static struct scsi_transport_template *iscsi_sw_tcp_scsi_transport;
> static struct scsi_host_template iscsi_sw_tcp_sht;
> static struct iscsi_transport iscsi_sw_tcp_transport;
> 
> -static unsigned int iscsi_max_lun = 512;
> +static unsigned int iscsi_max_lun = ~0;
> module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);

Ok. Thanks.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

