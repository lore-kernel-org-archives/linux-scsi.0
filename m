From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] scsi_transport_fc: implement 'disable_target_scan'
 module parameter
Date: Wed, 2 Mar 2016 17:35:36 +0800
Message-ID: <56D6B3E8.1080607@suse.de>
References: <1456127462-2817-1-git-send-email-hare@suse.de>
 <1456127462-2817-2-git-send-email-hare@suse.de>
 <20160301131252.GA7786@lst.de> <56D6814B.9020302@suse.de>
 <20160302091842.GD1308@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34361 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753065AbcCBJfw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2016 04:35:52 -0500
In-Reply-To: <20160302091842.GD1308@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jthumshirn@suse.com>, linux-scsi@vger.kernel.org

On 03/02/2016 05:18 PM, Christoph Hellwig wrote:
> On Wed, Mar 02, 2016 at 01:59:39PM +0800, Hannes Reinecke wrote:
>> Main reasons being that
>> a) it's most commonly on FC where you end up having thousands of LUN=
s;
>> SAS domains are of finite size and you'd need to string quite a few =
SAS
>> expanders together to achieve a similar setup. And iSCSI is ... well=
=2E
>> b) FC already has the required infrastructure in place where you eas=
ily
>> can suppress a target scan, making the patch really trivial.
>>
>> So rather than trying to come up with a generic solution and an over=
ly
>> complicated patch I opted for the simpler version :-)
>=20
> Having a global disable just for all FC is still odd.  Either you
> do it for all devices and always initiate a manual scan, or you
> need to do it on a per-host basis somehow.
>=20
Understood.

Will be resubmitting with a global switch for all SCSI hosts.

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
