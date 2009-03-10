From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH]scsi_dh_rdac: Retry for NOT_READY check condition (0x02A102,
 0x020401, 0x020404 and  0x020407) in rdac_check_sense
Date: Tue, 10 Mar 2009 16:26:10 +0100
Message-ID: <49B68692.9020308@suse.de>
References: <0D1E8821739E724A86F4D16902CE275C140E25CA0C@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:48139 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747AbZCJP0P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Mar 2009 11:26:15 -0400
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C140E25CA0C@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>

Chauhan, Vijay wrote:
> This patch adds retry for NOT_READY check conditions(02/A1/02, 02/04/=
01, 02/04/04,
> 02/04/07) in rdac_check_sense.
>=20
> Signed-off-by: Vijay Chauhan<vijay.chauhan@lsi.com>
>=20
Signed-off-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
