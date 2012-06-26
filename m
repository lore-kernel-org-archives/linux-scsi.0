From: Josh Hunt <johunt@akamai.com>
Subject: Re: [PATCH 1/2] scsi: propery initialize atomic_t ioerr_cnt
Date: Mon, 25 Jun 2012 23:37:23 -0500
Message-ID: <4FE93C83.1020909@akamai.com>
References: <1339250619-1561-1-git-send-email-johunt@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from prod-mail-xrelay05.akamai.com ([96.6.114.97]:60959 "EHLO
	prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416Ab2FZEhZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jun 2012 00:37:25 -0400
In-Reply-To: <1339250619-1561-1-git-send-email-johunt@akamai.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Josh Hunt <johunt@akamai.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 06/09/2012 09:03 AM, Josh Hunt wrote:
> Initialize atomic_t ioerr_cnt as per the guidelines defined in Documentation/atomic_ops.txt
> 
> Reported-by: Debabrata Banerjee <dbanerje@akamai.com>
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>  drivers/scsi/sd.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 6f0a4c6..8b85703 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2702,6 +2702,7 @@ static int sd_probe(struct device *dev)
>  	sdkp->disk = gd;
>  	sdkp->index = index;
>  	atomic_set(&sdkp->openers, 0);
> +	atomic_set(&sdkp->device->ioerr_cnt, 0);
>  
>  	if (!sdp->request_queue->rq_timeout) {
>  		if (sdp->type != TYPE_MOD)

Ping?

I know these are trivial, but they seem to be correct. If not, I'd be
interested to understand why.

Thanks
Josh
