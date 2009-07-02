From: Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH] Add BLIST_REPORTLUN2 to EMC SYMMETRIX
Date: Thu, 2 Jul 2009 10:23:28 +0200
Message-ID: <200907021023.29092.jdelvare@suse.de>
References: <200907012018.13695.jdelvare@suse.de> <1246476812.3894.56.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:52869 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579AbZGBIX1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2009 04:23:27 -0400
In-Reply-To: <1246476812.3894.56.camel@mulgrave.site>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Kurt Garloff <garloff@suse.de>, Hannes Reinecke <hare@suse.de>

Le mercredi 01 juillet 2009, James Bottomley a =E9crit=A0:
> On Wed, 2009-07-01 at 20:18 +0200, Jean Delvare wrote:
> > From: Kurt Garloff <garloff@suse.de>
> >=20
> > All EMC SYMMETRIX support REPORT_LUNS, even if configured to report
> > SCSI-2 for whatever reason.
> >=20
> > Signed-off-by: Kurt Garloff <garloff@suse.de>
> > Signed-off-by: Hannes Reinecke <hare@suse.de>
> > Signed-off-by: Jean Delvare <jdelvare@suse.de>
> > ---
> > We have this fix in our SLES10 kernel for over a year now, I guess
> > it's about time to get it upstream so that everyone benefits.
> >=20
> > Patch already sent on:
> >  * 2009-05-29
>=20
> The SCSI mailing list doesn't find it.

Indeed. Very strange, as my mailer is positive it did send it. Must
have been lost on the road... sorry.

--=20
Jean Delvare
Suse L3
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
