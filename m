From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 09/18] scsi_dh_alua: fixup description of stpg_endio()
Date: Tue, 01 Dec 2015 11:09:00 +0100
Message-ID: <1448964540.3103.8.camel@suse.com>
References: <1448961418-29013-1-git-send-email-hare@suse.de>
	 <1448961418-29013-10-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565AbbLAKJB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 05:09:01 -0500
In-Reply-To: <1448961418-29013-10-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <jbottomley@odin.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Tue, 2015-12-01 at 10:16 +0100, Hannes Reinecke wrote:
> Fixup copy-and-paste error in the description of stpg_endio().
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
> =C2=A0drivers/scsi/device_handler/scsi_dh_alua.c | 6 ++----
> =C2=A01 file changed, 2 insertions(+), 4 deletions(-)
>=20
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c
> b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 50fe87c..ea626732 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -171,13 +171,11 @@ done:
> =C2=A0}
> =C2=A0
> =C2=A0/*
> - * alua_stpg - Evaluate SET TARGET GROUP STATES
> + * stpg_endio - Evaluate SET TARGET GROUP STATES
> =C2=A0 * @sdev: the device to be evaluated
> =C2=A0 * @state: the new target group state
> =C2=A0 *
> - * Send a SET TARGET GROUP STATES command to the device.
> - * We only have to test here if we should resubmit the command;
> - * any other error is assumed as a failure.
> + * Evaluate a SET TARGET GROUP STATES command response.
> =C2=A0 */
> =C2=A0static void stpg_endio(struct request *req, int error)
> =C2=A0{

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
