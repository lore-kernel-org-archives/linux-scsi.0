From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi: add module alias
Date: Thu, 09 Dec 2010 15:37:52 -0600
Message-ID: <4D014C30.9050803@cs.wisc.edu>
References: <20101209093756.06210c6a@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45144 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757344Ab0LIVcT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2010 16:32:19 -0500
In-Reply-To: <20101209093756.06210c6a@nehalam>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: Stephen Hemminger <shemminger@vyatta.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On 12/09/2010 11:37 AM, Stephen Hemminger wrote:
> Since iscsi transport can be built as a module and uses netlink socket
> to communicate. The module should have an alias to autoload when socket
> of NETLINK_ISCSI type is requested.
>
> Signed-off-by: Stephen Hemminger<shemminger@vyatta.com>
>
> --- a/drivers/scsi/scsi_transport_iscsi.c	2010-12-09 09:21:42.784962783 -0800
> +++ b/drivers/scsi/scsi_transport_iscsi.c	2010-12-09 09:22:40.812352712 -0800
> @@ -2200,3 +2200,4 @@ MODULE_AUTHOR("Mike Christie<michaelc@c
>   MODULE_DESCRIPTION("iSCSI Transport Interface");
>   MODULE_LICENSE("GPL");
>   MODULE_VERSION(ISCSI_TRANSPORT_VERSION);
> +MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_ISCSI);
>

Thanks for the patch. Looks ok to me.

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
