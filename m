From: Konrad Rzeszutek <ketuzsezr@darnok.org>
Subject: Re: [2.6 patch] drivers/firmware/iscsi_ibft.c: make 3 functions static
Date: Wed, 23 Apr 2008 07:24:42 -0400
Message-ID: <200804230724.42697.ketuzsezr@darnok.org>
References: <20080423095230.GK28933@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andromeda.dapyr.net ([206.212.254.10]:59166 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbYDWLlH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Apr 2008 07:41:07 -0400
In-Reply-To: <20080423095230.GK28933@cs181133002.pp.htv.fi>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: Konrad Rzeszutek <ketuzsezr@darnok.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wednesday 23 April 2008 05:52:30 Adrian Bunk wrote:
> This patch makes the following needlessly global functions static:
> - ibft_attr_show_initiator()
> - ibft_attr_show_nic()
> - ibft_attr_show_target()
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Thanks for catching that.

Signed-off-by: Konrad Rzeszutek <ketuzsezr@darnok.org>

>
> ---
>
>  drivers/firmware/iscsi_ibft.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> 421adc9620a633d461059da9a8a94315d8a767ea diff --git
> a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c index
> 8024e3b..8523811 100644
> --- a/drivers/firmware/iscsi_ibft.c
> +++ b/drivers/firmware/iscsi_ibft.c
> @@ -334,9 +334,9 @@ static void ibft_release(struct kobject *kobj)
>  /*
>   *  Routines for parsing the iBFT data to be human readable.
>   */
> -ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
> -				  struct ibft_attribute *attr,
> -				  char *buf)
> +static ssize_t ibft_attr_show_initiator(struct ibft_kobject *entry,
> +					struct ibft_attribute *attr,
> +					char *buf)
>  {
>  	struct ibft_initiator *initiator = entry->initiator;
>  	void *ibft_loc = entry->header;
> @@ -376,9 +376,9 @@ ssize_t ibft_attr_show_initiator(struct ibft_kobject
> *entry, return str - buf;
>  }
>
> -ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
> -			    struct ibft_attribute *attr,
> -			    char *buf)
> +static ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
> +				  struct ibft_attribute *attr,
> +				  char *buf)
>  {
>  	struct ibft_nic *nic = entry->nic;
>  	void *ibft_loc = entry->header;
> @@ -440,9 +440,9 @@ ssize_t ibft_attr_show_nic(struct ibft_kobject *entry,
>  	return str - buf;
>  };
>
> -ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
> -			       struct ibft_attribute *attr,
> -			       char *buf)
> +static ssize_t ibft_attr_show_target(struct ibft_kobject *entry,
> +				     struct ibft_attribute *attr,
> +				     char *buf)
>  {
>  	struct ibft_tgt *tgt = entry->tgt;
>  	void *ibft_loc = entry->header;


