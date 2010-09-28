From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 3/3] tcm/fileio: Add UNMAP / Block DISCARD support
Date: Tue, 28 Sep 2010 23:06:22 +0200
Message-ID: <201009282306.23514.eike-kernel@sf-tec.de>
References: <1285627910-6492-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1384148.rnYdPORNX9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:56957 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab0I1VG3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2010 17:06:29 -0400
In-Reply-To: <1285627910-6492-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>

--nextPart1384148.rnYdPORNX9
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Nicholas A. Bellinger wrote:

> @@ -433,6 +448,42 @@ static int fd_emulate_scsi_cdb(struct se_task *task)
>  		if (ret < 0)
>  			return ret;
>  		break;
> +	case UNMAP:
> +		i = igrab(f->f_mapping->host);
> +		if (!(i)) {

.....

> +		if (!(S_ISBLK(i->i_mode))) {

.....

> +		if (!(bd)) {

Is this LISP or what? ;)

Eike

--nextPart1384148.rnYdPORNX9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAkyiWM8ACgkQXKSJPmm5/E7KkQCgglTnTW8gFujWZfXnnB02k8SQ
SNYAoIgVZr4uyPQKirWkOEW9VEE43Vuc
=1/fv
-----END PGP SIGNATURE-----

--nextPart1384148.rnYdPORNX9--
