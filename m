From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: RE: [dm-devel] [RESEND][PATCH 2/4] scsi_dh_hp_sw: Adding the match function for hp_sw device handler
Date: Fri, 4 Nov 2011 09:33:27 -0400
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD9105DC296@RTPMVEXC1-PRD.hq.netapp.com>
References: <47D23AD8469A2B448F33C24BD7A39BD9105DBE63@RTPMVEXC1-PRD.hq.netapp.com> <4EB39532.3020904@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:46335 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab1KDNdp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Nov 2011 09:33:45 -0400
Content-class: urn:content-classes:message
In-Reply-To: <4EB39532.3020904@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, device-mapper development <dm-devel@redhat.com>
Cc: Linux SCSI Mailing list <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Friday, November 04, 2011 2:33 AM
> To: device-mapper development
> Cc: Moger, Babu; Linux SCSI Mailing list
> Subject: Re: [dm-devel] [RESEND][PATCH 2/4] scsi_dh_hp_sw: Adding the
> match function for hp_sw device handler
>=20
> Hi Babu,
>=20
> On 11/03/2011 04:51 PM, Moger, Babu wrote:
> > This patch introduces the match function for hp_sw device handler.
> > The match function was introduced by this patch
> > http://www.spinics.net/lists/linux-scsi/msg54284.html
> >
> > Signed-off-by: Babu Moger<babu.moger@netapp.com>
>=20
> Actually, the old HP MSA has a firmware update which also makes it
> ALUA capable. So we would need to add the check here, too.

Sure.. I will add the TPGS check and resend this patch.. Thanks..

>=20
> Cheers,
>=20
> Hannes
> --
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
