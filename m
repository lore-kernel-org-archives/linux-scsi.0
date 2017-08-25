From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 19/19] iscsi_tcp: Remove a set-but-not-used variable
Date: Fri, 25 Aug 2017 17:53:48 +0200
Message-ID: <89e41d47-7cd8-38cb-ea10-b8faeaa90e7a@suse.de>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
 <20170823214009.15015-20-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43240 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933894AbdHYPxu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 11:53:50 -0400
In-Reply-To: <20170823214009.15015-20-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Lee Duncan <lduncan@suse.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

On 08/23/2017 11:40 PM, Bart Van Assche wrote:
> This patch avoids that gcc reports the following warning when
> building with W=1:
> 
> drivers/scsi/iscsi_tcp.c:166:24: warning: variable ?session? set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Lee Duncan <lduncan@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/iscsi_tcp.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
> index 4842fc0e809d..4d934d6c3e13 100644
> --- a/drivers/scsi/iscsi_tcp.c
> +++ b/drivers/scsi/iscsi_tcp.c
> @@ -163,7 +163,6 @@ static void iscsi_sw_tcp_state_change(struct sock *sk)
>  	struct iscsi_tcp_conn *tcp_conn;
>  	struct iscsi_sw_tcp_conn *tcp_sw_conn;
>  	struct iscsi_conn *conn;
> -	struct iscsi_session *session;
>  	void (*old_state_change)(struct sock *);
>  
>  	read_lock_bh(&sk->sk_callback_lock);
> @@ -172,7 +171,6 @@ static void iscsi_sw_tcp_state_change(struct sock *sk)
>  		read_unlock_bh(&sk->sk_callback_lock);
>  		return;
>  	}
> -	session = conn->session;
>  
>  	iscsi_sw_sk_state_check(sk);
>  
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
