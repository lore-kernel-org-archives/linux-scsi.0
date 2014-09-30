From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi_host: fix comment
Date: Tue, 30 Sep 2014 13:13:24 +0200
Message-ID: <542A9054.1000306@acm.org>
References: <20140920133755.0000496a@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from michel.telenet-ops.be ([195.130.137.88]:43716 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaI3LNb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Sep 2014 07:13:31 -0400
In-Reply-To: <20140920133755.0000496a@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>, linux-scsi@vger.kernel.org
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>

On 09/20/14 13:37, Sebastian Herbszt wrote:
> Commit 1abf635 (scsi: use 64-bit value for 'max_luns') changed the order
> of Scsi_Host members. Update the comment to reflect this.
>
> Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
>
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index ba20347..d4e0509 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -603,13 +603,13 @@ struct Scsi_Host {
>   	unsigned long last_reset;
>
>
>   	/*
>   	 * These three parameters can be used to allow for wide scsi,
>   	 * and for host adapters that support multiple busses
> -	 * The first two should be set to 1 more than the actual max id
> +	 * The last two should be set to 1 more than the actual max id
>   	 * or lun (e.g. 8 for SCSI parallel systems).
>   	 */
>   	unsigned int max_channel;
>   	unsigned int max_id;
>   	u64 max_lun;

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
