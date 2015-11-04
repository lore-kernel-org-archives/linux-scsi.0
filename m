From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] st: trivial: remove form feed characters
Date: Wed, 04 Nov 2015 13:54:51 -0800
Message-ID: <1446674091.2216.9.camel@HansenPartnership.com>
References: <1446630733-19305-1-git-send-email-mlombard@redhat.com>
	 <40EEE525-186E-453F-B597-160E6AED58A1@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52800 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030782AbbKDVy4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 16:54:56 -0500
In-Reply-To: <40EEE525-186E-453F-B597-160E6AED58A1@kolumbus.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "\"Kai =?ISO-8859-1?Q?M=E4kisara?= (Kolumbus)\"" <kai.makisara@kolumbus.fi>
Cc: Maurizio Lombardi <mlombard@redhat.com>, trivial@kernel.org, linux-scsi@vger.kernel.org

On Wed, 2015-11-04 at 23:04 +0200, "Kai M=C3=A4kisara (Kolumbus)" wrote=
:
> > On 4.11.2015, at 11.52, Maurizio Lombardi <mlombard@redhat.com> wro=
te:
> >=20
> > Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> > ---
> > drivers/scsi/st.c | 24 ++++++++----------------
> > 1 file changed, 8 insertions(+), 16 deletions(-)
> >=20
> > diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> > index b37b9b0..7c4e518 100644
> > --- a/drivers/scsi/st.c
> > +++ b/drivers/scsi/st.c
> > @@ -226,7 +226,6 @@ static DEFINE_SPINLOCK(st_use_lock);
> > static DEFINE_IDR(st_index_idr);
> >=20
> >=20
> > -=0C
>=20
> What=E2=80=99s the point? Is there an =E2=80=9Cofficial=E2=80=9D rule=
 that form feeds are not allowed (to
> put different things to different pages in printout)?

No, no official rule.  If you want to keep the form feed, that's fine,
we won't apply this patch.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
