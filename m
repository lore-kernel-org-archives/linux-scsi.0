From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/3] bnx2i: Add bnx2i iSCSI driver.
Date: Wed, 28 May 2008 10:47:01 +0200
Message-ID: <483D1C05.70101@suse.de>
References: <ada8wy07osq.fsf@cisco.com> <1211578969.26900.5.camel@dhcp-10-13-110-217.broadcom.com> <adave0z24o4.fsf@cisco.com> <20080527.125247.73979652.davem@davemloft.net> <1211935729.18326.185.camel@dell> <483CD3F3.6070308@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <483CD3F3.6070308@garzik.org>
Sender: netdev-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Michael Chan <mchan@broadcom.com>, David Miller <davem@davemloft.net>, rdreier@cisco.com, anilgv@broadcom.com, michaelc@cs.wisc.edu, netdev <netdev@vger.kernel.org>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

Hi all,

Jeff Garzik wrote:
> Michael Chan wrote:
>> If we change the implementation to use a separate IP address and
>> separate MAC address for iSCSI, will it be acceptable?  The iSCSI IP=
/MAC
>> addresses will be unknown to the Linux TCP stack and so no sharing o=
f
>> the 4-tuple space will be needed.
>>
>> The patches will be very similar, except that all inet calls and
>> notifiers will be removed.
>=20
>=20
> IMO a totally separate MAC and IP would definitely be preferred...
>=20
And as it happens, the machines I have here claim to use a different
MAC address for iSCSI anyway. So we should be using them.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
