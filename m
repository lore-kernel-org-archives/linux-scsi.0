From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 4/5] scsi_debug: change SCSI command parser to table
 driven
Date: Tue, 25 Nov 2014 08:04:35 +0100
Message-ID: <54742A03.90600@suse.de>
References: <5474000A.2030501@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbaKYHEh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2014 02:04:37 -0500
In-Reply-To: <5474000A.2030501@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@ORACLE.COM>

On 11/25/2014 05:05 AM, Douglas Gilbert wrote:
> +	case 0x53:	/* XDWRITEREAD(10) */
> +		ei_lba =3D 0;
> +		lba =3D get_unaligned_be32(cmd + 2);
> +		num =3D get_unaligned_be16(cmd + 7);
> +		check_prot =3D false;
> +		break;
Why not use 'XDWRITEREAD_10' here?
It did work in the original version ...

(This is the bit I meant :-)

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 21284 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
