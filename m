From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RESEND 9/18] megaraid_sas : Support for Avago's Single
 server High Availability product
Date: Tue, 21 Apr 2015 12:28:44 +0200
Message-ID: <5536265C.303@suse.de>
References: <201504201236.t3KCa2D0016595@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34284 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbbDUKns (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 06:43:48 -0400
In-Reply-To: <201504201236.t3KCa2D0016595@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On 04/20/2015 02:33 PM, Sumit.Saxena@avagotech.com wrote:
> This patch will add support for Single Server High Availability(SSHA)=
 cluster support.
> Here is the short decsription of changes done to add support for SSHA=
-
> 1) Host will send system's Unique ID based on DMI_PRODUCT_UUID to fir=
mware.
> 2) Toggle the devhandle in LDIO path for Remote LDs. =20
>=20
> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
>=20
> ---
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
