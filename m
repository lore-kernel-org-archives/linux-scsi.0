From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 05/17] be2iscsi:Fix typo function name mismatch
Date: Thu, 22 Mar 2012 07:52:36 +0000
Message-ID: <1332402756.2946.5.camel@dabdike.int.hansenpartnership.com>
References: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu>
	 <1332294488-13684-6-git-send-email-michaelc@cs.wisc.edu>
	 <5978796.vmDf5npbmM@eto>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57659 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753276Ab2CVHwn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2012 03:52:43 -0400
In-Reply-To: <5978796.vmDf5npbmM@eto>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Minh Tran <MinhDuc.Tran@emulex.com>

On Wed, 2012-03-21 at 23:21 +0100, Rolf Eike Beer wrote:
> Am Dienstag 20 M=C3=A4rz 2012, 20:47:56 schrieb michaelc@cs.wisc.edu:
> > From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> >=20
> > Signed-off-by: Minh Tran <MinhDuc.Tran@Emulex.Com>
> > Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> > Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> > ---
> >  drivers/scsi/be2iscsi/be_iscsi.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/drivers/scsi/be2iscsi/be_iscsi.c
> > b/drivers/scsi/be2iscsi/be_iscsi.c index 33c8f09..2bb681e 100644
> > --- a/drivers/scsi/be2iscsi/be_iscsi.c
> > +++ b/drivers/scsi/be2iscsi/be_iscsi.c
> > @@ -221,7 +221,7 @@ int beiscsi_ep_get_param(struct iscsi_endpoint =
*ep,
> >  	struct beiscsi_endpoint *beiscsi_ep =3D ep->dd_data;
> >  	int len =3D 0;
> >=20
> > -	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_get_param, param=3D %d\n", p=
aram);
> > +	SE_DEBUG(DBG_LVL_8, "In beiscsi_ep_get_param, param=3D %d\n", par=
am);
> >=20
> >  	switch (param) {
> >  	case ISCSI_PARAM_CONN_PORT:
>=20
> What about:
>=20
> SE_DEBUG(DBG_LVL_8, "In %s, param=3D %d\n", __func__, param);

It's a matter of taste which I defer to the driver writer, but
personally I dislike the style you propose.  The reason being when I se=
e
a message I want to investigate in the kernel logs I tend to git grep
the kernel for it.  In your case, I won't find it.  It's far more usefu=
l
that the message be greppable than it be accurate about what function
it's actually in.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
