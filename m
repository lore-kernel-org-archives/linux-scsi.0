From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/7] scsi_dh: Update EMC handler
Date: Thu, 15 May 2008 10:09:16 +0200
Message-ID: <482BEFAC.7030400@suse.de>
References: <20080514144324.3000410B5DF@craiglockhart-ipmi.suse.de> <1210819629.21974.255.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:57686 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbYEOIJS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2008 04:09:18 -0400
In-Reply-To: <1210819629.21974.255.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@us.ibm.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, dm-devel <dm-devel@redhat.com>

Hi Chandra,

Chandra Seetharaman wrote:
> On Wed, 2008-05-14 at 16:43 +0200, Hannes Reinecke wrote:
> <snip>
>=20
>> @@ -438,10 +604,32 @@ static int clariion_bus_attach(struct scsi_dev=
ice *sdev)
>>  	sdev->scsi_dh_data =3D scsi_dh_data;
>>  	spin_unlock_irqrestore(sdev->request_queue->queue_lock, flags);
>>
> Can move the block above to be just before try_module_get() and avoid
> undoing it in the failed path.
>=20
Hmm. Yes, we could. But that means I have to pass the scsi_dh_data stru=
cture
to basically every function.
Let me check how this pans out.

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
