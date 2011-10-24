From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 7/9] ib_srpt: Convert srp_max_rdma_size into per port
 configfs attribute
Date: Mon, 24 Oct 2011 13:29:55 -0700
Message-ID: <1319488195.17450.73.camel@haakon2.linux-iscsi.org>
References: <1319434422-15354-1-git-send-email-nab@linux-iscsi.org>
	 <1319434422-15354-8-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1319434422-15354-8-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2011-10-24 at 05:33 +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch converts the srp_max_rdma_size module parameter into a per
> endpoint configfs attribute.  This includes adding the necessary bits
> for show + store attributes w/ min/max bounds checking, and updating
> srpt_get_ioc() to accept a struct srpt_port parameter.
> 
> Reported-by: Roland Dreier <roland@purestorage.com>
> Cc: Roland Dreier <roland@purestorage.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c |   60 ++++++++++++++++++++++++++++-----
>  drivers/infiniband/ulp/srpt/ib_srpt.h |   10 +++++
>  2 files changed, 61 insertions(+), 9 deletions(-)
> 

<SNIP>

> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
> index 59ee2d7..c9caa90 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.h
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
> @@ -114,6 +114,7 @@ enum {
>  	MIN_SRPT_SRQ_SIZE = 4,
>  	DEFAULT_SRPT_SRQ_SIZE = 4095,
>  	MAX_SRPT_SRQ_SIZE = 65535,
> +	MAX_SRPT_RDMA_SIZE = 256U,
>  

Hey btw, what should the proper MAX_SRPT_RDMA_SIZE be here..?

--nab
