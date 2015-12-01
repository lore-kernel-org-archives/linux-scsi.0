From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 10/18] scsi: remove scsi_show_sense_hdr()
Date: Tue, 01 Dec 2015 11:09:36 +0100
Message-ID: <1448964576.3103.9.camel@suse.com>
References: <1448961418-29013-1-git-send-email-hare@suse.de>
	 <1448961418-29013-11-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759AbbLAKJh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Dec 2015 05:09:37 -0500
In-Reply-To: <1448961418-29013-11-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <jbottomley@odin.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Tue, 2015-12-01 at 10:16 +0100, Hannes Reinecke wrote:
> Last caller is gone, so remove it.
>=20
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0include/scsi/scsi_dbg.h | 2 --
> =C2=A01 file changed, 2 deletions(-)
>=20
> diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
> index f8170e9..56710e0 100644
> --- a/include/scsi/scsi_dbg.h
> +++ b/include/scsi/scsi_dbg.h
> @@ -12,8 +12,6 @@ extern size_t __scsi_format_command(char *, size_t,
> =C2=A0				=C2=A0=C2=A0=C2=A0const unsigned char *, size_t);
> =C2=A0extern void scsi_show_extd_sense(const struct scsi_device *, co=
nst char *,
> =C2=A0				=C2=A0unsigned char, unsigned char);
> -extern void scsi_show_sense_hdr(const struct scsi_device *, const ch=
ar *,
> -				const struct scsi_sense_hdr *);
> =C2=A0extern void scsi_print_sense_hdr(const struct scsi_device *, co=
nst char *,
> =C2=A0				=C2=A0const struct scsi_sense_hdr *);
> =C2=A0extern void scsi_print_sense(const struct scsi_cmnd *);

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
