From: Hannes Reinecke <hare@suse.de>
Subject: Re: qla2xxx: automatically rescan removed luns.
Date: Thu, 28 Nov 2013 14:29:23 +0100
Message-ID: <52974533.3030508@suse.de>
References: <52936EB4.4090508@mpstor.com> <1385399823.3839.116.camel@localhost.localdomain> <5294C721.4070802@mpstor.com> <5294CBC7.3000604@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045Ab3K1N3Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Nov 2013 08:29:24 -0500
In-Reply-To: <5294CBC7.3000604@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, Benjamin ESTRABAUD <be@mpstor.com>, emilne@redhat.com
Cc: linux-scsi@vger.kernel.org

On 11/26/2013 05:26 PM, Douglas Gilbert wrote:
> On 13-11-26 11:06 AM, Benjamin ESTRABAUD wrote:
[ .. ]
>> "rescan-scsi-bus.sh" did detect new LUN, but apparently not
>> removed ones.
>> However I need to test it on a system with a compatible bash shell
>> as I wasn't
>> able to run the script without errors.
>=20
> Did you try the rescan-scsi-bus.sh from sg3_utils v 1.37 or
> earlier? The reason I ask is that a fair amount of work
> was done on the rescan-scsi-bus.sh found in version 1.37
> including syncing with Kurt Garloff's version 1.57 plus
> patches from Hannes Reinecke and Sean Stewart.
>=20
Plus you need to call it with '-r', otherwise it won't remove any
stale LUNs. I'm sure it's documented somewhere ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
