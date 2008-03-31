From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [2.6 patch] make scsi_end_bidi_request() static
Date: Mon, 31 Mar 2008 10:19:23 +0300
Message-ID: <47F0907B.4010807@panasas.com>
References: <20080330225355.GK28445@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:37335 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbYCaHTq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Mar 2008 03:19:46 -0400
In-Reply-To: <20080330225355.GK28445@cs181133002.pp.htv.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Mar 31 2008 at 1:53 +0300, Adrian Bunk <bunk@kernel.org> wrote:
> This patch makes the needlessly global scsi_end_bidi_request() static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
> This patch has been sent on:
> - 27 Feb 2008
> - 13 Feb 2008
> 
> 48e50a33ee11afb02eadc790ae2d9542b0805608 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b12fb31..148c8b0 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -785,7 +785,7 @@ EXPORT_SYMBOL(scsi_release_buffers);
>   * in req->data_len and req->next_rq->data_len. The upper-layer driver can
>   * decide what to do with this information.
>   */
> -void scsi_end_bidi_request(struct scsi_cmnd *cmd)
> +static void scsi_end_bidi_request(struct scsi_cmnd *cmd)
>  {
>  	struct request *req = cmd->request;
>  	unsigned int dlen = req->data_len;
> 
> --
I thought it went in. Yes it is good. Sorry about that.

Boaz
