From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi: fix scsi_transport_iscsi kernel-doc notation
Date: Mon, 16 Aug 2010 15:44:33 -0500
Message-ID: <4C69A331.5020309@cs.wisc.edu>
References: <20100814130541.054a0096.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36829 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213Ab0HPUqV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Aug 2010 16:46:21 -0400
In-Reply-To: <20100814130541.054a0096.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, jejbscsi <james.bottomley@suse.de>, akpm <akpm@linux-foundation.org>

On 08/14/2010 03:05 PM, Randy Dunlap wrote:
> From: Randy Dunlap<randy.dunlap@oracle.com>
>
> Fix typo in scsi_transport_iscsi.c kernel-doc notation:
>
> Warning(drivers/scsi/scsi_transport_iscsi.c:548): No description found for parameter 'cmd'
>
> Signed-off-by: Randy Dunlap<randy.dunlap@oracle.com>
> ---
>   drivers/scsi/scsi_transport_iscsi.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- linux-2.6.35-git8.orig/drivers/scsi/scsi_transport_iscsi.c
> +++ linux-2.6.35-git8/drivers/scsi/scsi_transport_iscsi.c
> @@ -537,7 +537,7 @@ static void iscsi_scan_session(struct wo
>
>   /**
>    * iscsi_block_scsi_eh - block scsi eh until session state has transistioned
> - * cmd: scsi cmd passed to scsi eh handler
> + * @cmd: scsi cmd passed to scsi eh handler
>    *
>    * If the session is down this function will wait for the recovery
>    * timer to fire or for the session to be logged back in. If the

Sorry I missed that. Thanks.

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
