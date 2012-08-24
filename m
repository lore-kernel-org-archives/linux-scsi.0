From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi_dh_alua: Enable STPG for unavailable ports
Date: Fri, 24 Aug 2012 11:37:14 -0500
Message-ID: <7373F391-C2DC-49A3-A862-DF0616F96C7C@cs.wisc.edu>
References: <50374499.5010808@acm.org>
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1485\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44871 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964839Ab2HXQhv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Aug 2012 12:37:51 -0400
In-Reply-To: <50374499.5010808@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, Babu Moger <babu.moger@netapp.com>


On Aug 24, 2012, at 4:08 AM, Bart Van Assche <bvanassche@acm.org> wrote:
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 08d80a6..a05d469 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -641,8 +641,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_dh_data *h)
> 		h->state = TPGS_STATE_STANDBY;
> 		break;
> 	case TPGS_STATE_OFFLINE:
> -	case TPGS_STATE_UNAVAILABLE:
> -		/* Path unusable for unavailable/offline */
> +		/* Path unusable */
> 		err = SCSI_DH_DEV_OFFLINED;
> 		break;
> 	default:

We must not have tested unavailable state very much. 3rd bug in a short time. Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>


