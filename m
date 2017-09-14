From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH v2 17/17] iscsi_tcp: Remove a set-but-not-used variable
Date: Thu, 14 Sep 2017 13:56:14 -0700
Message-ID: <21190fcf-1f7a-45d0-4042-eca9039a57c2@suse.com>
References: <20170825204643.25043-1-bart.vanassche@wdc.com>
 <20170825204643.25043-18-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46206 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751366AbdINU4T (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Sep 2017 16:56:19 -0400
In-Reply-To: <20170825204643.25043-18-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>



On 08/25/2017 01:46 PM, Bart Van Assche wrote:
> This patch avoids that gcc reports the following warning when
> building with W=1:
> 
> drivers/scsi/iscsi_tcp.c:166:24: warning: variable ?session? set but not used [-Wunused-but-set-variable]
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Cc: Lee Duncan <lduncan@suse.com>
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

Reviewed-by: Lee Duncan <lduncan@suse.com>
-- 
Lee Duncan
