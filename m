From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Serial ATA (SATA) for Linux status report
Date: Thu, 04 Dec 2003 10:01:06 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3FCF4C32.5040101@pobox.com>
References: <20031203204445.GA26987@gtf.org> <20031204081732.GC5376@launay.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20031204081732.GC5376@launay.org>
To: Arnaud Launay <asl@launay.org>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Arnaud Launay wrote:
> Le Wed, Dec 03, 2003 at 03:44:46PM -0500, Jeff Garzik a =E9crit:
>=20
>>Intel ICH5
>>----------
>>Summary:  No TCQ.  Looks like a PATA controller, but with a few
>>added, non-standard SATA port controls.
>=20
>=20
> No plan to add the so-called "raid" capabilities of the 82801EB ?

AFAIK the raid capabilities are entirely in software.

And Intel just wrote and posted this component.  Look for "iswraid" in=20
the linux-kernel archives.


>>Silicon Image 3112
>=20
>=20
> Same here, is support for the 3114 underway ? Saw a message from

Underway, but beyond that cannot comment :)

	Jeff
