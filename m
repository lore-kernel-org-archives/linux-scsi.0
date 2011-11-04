From: Hannes Reinecke <hare@suse.de>
Subject: Re: [dm-devel] [RESEND][PATCH 4/4] scsi_dh: code cleanup and remove
 the	references to scsi_dev_info
Date: Fri, 04 Nov 2011 08:35:14 +0100
Message-ID: <4EB395B2.7030209@suse.de>
References: <47D23AD8469A2B448F33C24BD7A39BD9105DBE66@RTPMVEXC1-PRD.hq.netapp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026Ab1KDHfP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Nov 2011 03:35:15 -0400
In-Reply-To: <47D23AD8469A2B448F33C24BD7A39BD9105DBE66@RTPMVEXC1-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: "Moger, Babu" <Babu.Moger@netapp.com>, Linux SCSI Mailing list <linux-scsi@vger.kernel.org>

On 11/03/2011 04:52 PM, Moger, Babu wrote:
> All the handlers have implemented the match function(look at patch 1,=
 2, 3).
> We don't need to use scsi_dev_info any more for matching purposes.
> Cleaning up the scsi_dh code.
>
> FYI..
> Match function was originally implemented by this
>
> http://www.spinics.net/lists/linux-scsi/msg54284.html
> or
> http://git.kernel.org/?p=3Dlinux/kernel/git/jejb/scsi-misc-2.6.git;a=3D=
commit;h=3D6c3633d08acf514e2e89aa95d2346ce9d64d719a
>
> Signed-off-by: Babu Moger<babu.moger@netapp.com>
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
