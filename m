From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 19/23] scsi_dh: add 'rescan' callback
Date: Fri, 12 Feb 2016 08:14:55 +0100
Message-ID: <56BD866F.5010202@suse.de>
References: <1454942086-128704-1-git-send-email-hare@suse.de>
 <1454942086-128704-20-git-send-email-hare@suse.de>
 <1455222453.22112.332.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbcBLHO5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Feb 2016 02:14:57 -0500
In-Reply-To: <1455222453.22112.332.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 02/11/2016 09:27 PM, Ewan Milne wrote:
> On Mon, 2016-02-08 at 15:34 +0100, Hannes Reinecke wrote:
>> If a device needs to be rescanned the device_handler might need
>> to be rechecked, too.
>> So add a 'rescan' callback to the device handler and call it
>> upon scsi_rescan_device().
>=20
> This comment should mention that you have also changed the Unit
> Attention handling of ASC/ASCQ 3F 03 INQUIRY DATA HAS CHANGED
> to automatically rescan the device (prior to the uevent).
>=20
True. I will be updating the comment if I need to resend the patchset.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
