From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [RESEND][PATCH 3/4] scsi_dh_rdac: Adding the match
 function for rdac device handler
Date: Fri, 04 Nov 2011 08:34:46 +0100
Message-ID: <4EB39596.4030909@suse.de>
References: <47D23AD8469A2B448F33C24BD7A39BD9105DBE65@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab1KDHer (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Nov 2011 03:34:47 -0400
In-Reply-To: <47D23AD8469A2B448F33C24BD7A39BD9105DBE65@RTPMVEXC1-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "Moger, Babu" <Babu.Moger@netapp.com>, Linux SCSI Mailing list <linux-scsi@vger.kernel.org>

On 11/03/2011 04:51 PM, Moger, Babu wrote:
> This patch introduces the match function for rdac device handler. Wit=
hout this,
> sometimes handler attach fails during the device_add. Included check =
for TPGS
> bit before proceeding further. The match function was introduced by t=
his patch
> http://www.spinics.net/lists/linux-scsi/msg54284.html
>
> Signed-off-by: Babu Moger<babu.moger@netapp.com>

As the real patch of checking VPD pages is a bit more involved (eg=20
we're taking the lock during ->match(), so invoking any I/O from=20
here will get tricky), it's a sensible interim solution.

Acked-by: Hannes Reinecke <hare@suse.de>

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
