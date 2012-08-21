From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] increase iscsi_tcp max_lun to ~0, don't care
Date: Tue, 21 Aug 2012 12:42:19 -0500
Message-ID: <5033C87B.8000002@cs.wisc.edu>
References: <1345070374-32058-1-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39176 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758022Ab2HURm0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Aug 2012 13:42:26 -0400
In-Reply-To: <1345070374-32058-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Evers <revers@redhat.com>
Cc: linux-scsi@vger.kernel.org

On 08/15/2012 05:39 PM, Rob Evers wrote:
> Signed-off-by: Rob Evers <revers@redhat.com>
> ---
>  drivers/scsi/iscsi_tcp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 9220861..1b91ca0 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -55,7 +55,7 @@ static struct scsi_transport_template *iscsi_sw_tcp_scsi_transport;
>  static struct scsi_host_template iscsi_sw_tcp_sht;
>  static struct iscsi_transport iscsi_sw_tcp_transport;
>  
> -static unsigned int iscsi_max_lun = 512;
> +static unsigned int iscsi_max_lun = ~0;
>  module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
>  
>  static int iscsi_sw_tcp_dbg;
> 

Not sure if you need my ack James, but just in case. Patch is ok with me.

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
