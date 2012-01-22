From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] SCSI:implement PM for st
Date: Sun, 22 Jan 2012 19:58:36 +0200 (EET)
Message-ID: <alpine.LNX.2.00.1201221957100.5707@kai.makisara.local>
References: <201201160931.33777.oneukum@suse.de>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811327-863041256-1327255119=:5707"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs15.mail.saunalahti.fi ([62.142.117.202]:55005 "EHLO
	vs15.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab2AVSFU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jan 2012 13:05:20 -0500
In-Reply-To: <201201160931.33777.oneukum@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-scsi@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811327-863041256-1327255119=:5707
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Jan 2012, Oliver Neukum wrote:

> From 595fa6688232fd68f221fc2734545d3e995c465a Mon Sep 17 00:00:00 2001
> From: Oliver Neukum <oliver@neukum.org>
> Date: Sun, 15 Jan 2012 00:16:51 +0100
> Subject: [PATCH] SCSI:implement PM for st
>=20
> This implements basic power management for SCSI tapes.
>=20
> Signed-off-by: Oliver Neukum <oneukum@suse.de>
> ---
>  drivers/scsi/st.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 9b28f39..9262cdf 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -1177,6 +1177,7 @@ static int check_tape(struct scsi_tape *STp, stru=
ct file *filp)

Acked-by: Kai M=C3=A4kisara <kai.makisara@kolumbus.fi>

Thanks,
Kai
---1463811327-863041256-1327255119=:5707--
