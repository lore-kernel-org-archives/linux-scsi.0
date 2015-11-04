From: =?utf-8?Q?=22Kai_M=C3=A4kisara_=28Kolumbus=29=22?=
	<kai.makisara@kolumbus.fi>
Subject: Re: [PATCH] st: trivial: remove form feed characters
Date: Wed, 4 Nov 2015 23:04:31 +0200
Message-ID: <40EEE525-186E-453F-B597-160E6AED58A1@kolumbus.fi>
References: <1446630733-19305-1-git-send-email-mlombard@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 9.1 \(3096.5\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vs14.mail.saunalahti.fi ([62.142.117.201]:52016 "EHLO
	vs14.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030567AbbKDVEh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 16:04:37 -0500
In-Reply-To: <1446630733-19305-1-git-send-email-mlombard@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: trivial@kernel.org, linux-scsi@vger.kernel.org


> On 4.11.2015, at 11.52, Maurizio Lombardi <mlombard@redhat.com> wrote=
:
>=20
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
> drivers/scsi/st.c | 24 ++++++++----------------
> 1 file changed, 8 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index b37b9b0..7c4e518 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -226,7 +226,6 @@ static DEFINE_SPINLOCK(st_use_lock);
> static DEFINE_IDR(st_index_idr);
>=20
>=20
> -=0C

What=E2=80=99s the point? Is there an =E2=80=9Cofficial=E2=80=9D rule t=
hat form feeds are not allowed (to
put different things to different pages in printout)?

Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
