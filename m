From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: disable automatic target scan
Date: Tue, 15 Mar 2016 07:53:53 +0100
Message-ID: <56E7B181.7090409@suse.de>
References: <1457710420-37769-1-git-send-email-hare@suse.de>
 <yq1y49kfwa9.fsf@sermon.lab.mkp.net> <56E7B006.6020809@suse.de>
 <20160315064837.GA9879@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50781 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbcCOGxz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2016 02:53:55 -0400
In-Reply-To: <20160315064837.GA9879@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 03/15/2016 07:48 AM, Christoph Hellwig wrote:
> On Tue, Mar 15, 2016 at 07:47:34AM +0100, Hannes Reinecke wrote:
>>> So "disabled" is "sometimes enabled" and "none" is "really disabled=
"?
>>> =20
>> 'disabled' means:
>> disable automatic scanning, but allow manual scanning via the 'scan'
>> attribute.
>=20
> maybe rename disabled to manual?  And improve the modoule parameter
> description while we're at it.
>=20
Okay, will be doing so.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
