From: "Moger, Babu" <Babu.Moger@netapp.com>
Subject: RE: [dm-devel] [PATCH] scsi_dh_alua: Fix the time inteval for alua rtpgcommands
Date: Wed, 2 Nov 2011 16:56:57 -0400
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD9105DBBA5@RTPMVEXC1-PRD.hq.netapp.com>
References: <47D23AD8469A2B448F33C24BD7A39BD91050E54E@RTPMVEXC1-PRD.hq.netapp.com> <47D23AD8469A2B448F33C24BD7A39BD9105DB9D5@RTPMVEXC1-PRD.hq.netapp.com> <4EB19FCF.8090402@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:58097 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab1KBU5C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2011 16:57:02 -0400
Content-class: urn:content-classes:message
In-Reply-To: <4EB19FCF.8090402@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, Linux SCSI Mailing list <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>

Thanks Hannes..

> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Wednesday, November 02, 2011 2:54 PM
> To: Moger, Babu
> Subject: Re: [dm-devel] [PATCH] scsi_dh_alua: Fix the time inteval fo=
r
> alua rtpgcommands
>=20
> On 11/02/2011 06:22 PM, Moger, Babu wrote:
> > Hannes, I did not see ur comment on this patch..  Any comments?
> >
> >> -----Original Message-----
> >> From: Moger, Babu
> >> Sent: Thursday, October 27, 2011 1:37 PM
> >> To: Linux SCSI Mailing list
> >> Cc: device-mapper development
> >> Subject: [dm-devel] [PATCH] scsi_dh_alua: Fix the time inteval for
> alua
> >> rtpgcommands
> >>
> >> This patch corrects the retry interval for alua rtpg command.
> Purpose
> >> was to retry the commands in seconds.
> >> But that was not happening. Reason is msleep takes argument in
> >> milliseconds.
> >>
> >> Also added minor text after successful attach.
> >>
> >> Signed-off-by: Babu Moger <babu.moger@netapp.com>
> >> CC: Hannes Reinecke <hare@suse.de>
> Ach, forgot about it.
>=20
> Yes, patch is okay.
>=20
> Cheers,
>=20
> Hannes
> --
> Dr. Hannes Reinecke              zSeries & Storage
> hare@suse.de                  +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
