From: Rob Evers <revers@redhat.com>
Subject: Re: [PATCH] increase iscsi_tcp max_lun to ~1, don't care
Date: Wed, 15 Aug 2012 18:24:33 -0400
Message-ID: <502C21A1.8090301@redhat.com>
References: <1345060245-30012-1-git-send-email-revers@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918Ab2HOWYd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Aug 2012 18:24:33 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7FMOX7M023601
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 15 Aug 2012 18:24:33 -0400
Received: from revers-dell.usersys.redhat.com (dhcp-185-85.bos.redhat.com [10.16.185.85])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q7FMOXhh006377
	for <linux-scsi@vger.kernel.org>; Wed, 15 Aug 2012 18:24:33 -0400
In-Reply-To: <1345060245-30012-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 08/15/2012 03:50 PM, Rob Evers wrote:
> Signed-off-by: Rob Evers<revers@redhat.com>
> ---
>   drivers/scsi/iscsi_tcp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 9220861..fc9dfd2 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -55,7 +55,7 @@ static struct scsi_transport_template *iscsi_sw_tcp_scsi_transport;
>   static struct scsi_host_template iscsi_sw_tcp_sht;
>   static struct iscsi_transport iscsi_sw_tcp_transport;
>
> -static unsigned int iscsi_max_lun = 512;
> +static unsigned int iscsi_max_lun = ~1;
>   module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
>
>   static int iscsi_sw_tcp_dbg;

should be ~0, not ~1.  I'll post another patch.
