From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCHv2] st: remove st_mutex
Date: Sun, 23 Sep 2012 10:25:23 +0300 (EEST)
Message-ID: <alpine.LNX.2.00.1209231023030.16292@kai.makisara.local>
References: <504E6B7C.9010407@suse.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811327-2069649490-1348385133=:16292"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs18.mail.saunalahti.fi ([62.142.117.199]:56610 "EHLO
	vs18.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab2IWHZf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Sep 2012 03:25:35 -0400
In-Reply-To: <504E6B7C.9010407@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811327-2069649490-1348385133=:16292
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Sep 2012, Lee Duncan wrote:

> From: Hannes Reinecke <hare@suse.com>
>=20
> The st_mutex was created when the BKL was removed, and
> prevents simultaneous st_open calls. It is better to
> protect just the necessary data.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Reviewed-by: Lee Duncan <lduncan@suse.com>

Acked-by: Kai M=C3=A4kisara <Kai.Makisara@kolumbus.fi>

>=20
> This patch is based on the "misc" branch of the SCSI tree
> and the 5-patch series for st sent by Jeff Mahoney 8/18/2012
> and Ack-ed by Kai on 8/20.
>=20

Thanks,
Kai

---1463811327-2069649490-1348385133=:16292--
