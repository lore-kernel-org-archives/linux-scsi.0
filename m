From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/16] scsi_dh_alua: parse target device id
Date: Mon, 17 Feb 2014 15:33:13 +0100
Message-ID: <53021DA9.9090408@suse.de>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-9-git-send-email-hare@suse.de> <52FE0793.9040505@acm.org> <52FE0A66.6050200@suse.de> <5302171A.9070507@acm.org> <5302181A.9080308@suse.de> <53021C6B.7040207@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbaBQOdP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Feb 2014 09:33:15 -0500
In-Reply-To: <53021C6B.7040207@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, James Bottomley <jbottomley@parallels.com>
Cc: Sean Stewart <sean.stewart@netapp.com>, Martin George <marting@netapp.com>, linux-scsi@vger.kernel.org

On 02/17/2014 03:27 PM, Bart Van Assche wrote:
> On 02/17/14 15:09, Hannes Reinecke wrote:
>> If the product ID is actually the array identification and not a
>> generic name, sure.
>> But if all ION arrays with the same FW level identify itself with
>> the same identifier it's kinda pointless :-)
>> Otherwise, yeah, that's easily done.
>>
>> But you might want to talk to your FW folks; if they were to update
>> VPD page 0x83 to include an target-specific identifier we'd be all
>> set ...
>=20
> The product ID indeed identifies an array.
>=20
> Updating VPD page 0x83 can be done easily for new FW releases. Howeve=
r,
> the target identification approach explained in the previous e-mail i=
s
> already in use at several customer sites and I'm not sure it will be
> possible to convince all of them to upgrade ...
>=20
Ok, fair enough.

Will be including it.

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
