From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [dm-devel] [multipath] SCSI device capacity mess
Date: Fri, 29 Oct 2004 16:12:17 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041029141217.GC32712@marowsky-bree.de>
References: <20041027084202.GD32712@marowsky-bree.de> <OFBD60D8A7.8D9B83B6-ON85256F3A.00670D96-88256F3A.00677FF3@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.in-addr.de ([212.8.193.158]:61419 "EHLO mx.in-addr.de")
	by vger.kernel.org with ESMTP id S263356AbUJ2Ome (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Oct 2004 10:42:34 -0400
Content-Disposition: inline
In-Reply-To: <OFBD60D8A7.8D9B83B6-ON85256F3A.00670D96-88256F3A.00677FF3@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi-owner@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2004-10-27T11:51:42, Bryan Henderson <hbryan@us.ibm.com> wrote:

> >In addition verifying the size and stuff it could also check that th=
e
> >paths really (still) point to the same device (by storing the LUN WW=
N in
> >the hw_handler context, for example)
>=20
> Just to eliminate any ambiguity here, using terminology from the=20
> standards:  A LUN is a logical unit number.  A WWN is a fibre channel=
 port=20
> or node name.  There's no such thing as a LUN WWN.  I presume you mea=
n to=20
> check the logical unit device identifier, which is the world wide uni=
que=20
> and persistent identifier of a logical unit.  (That's what you get (a=
mong=20
> other things) from Page 0x83 of the SCSI VPD read from the LU).

Thanks for the clarification; EMC at least partially calls said
world-wide unique identifier the "LUN's WWN" though. And if we are
nitpicking, it's EVPD. ;-)



Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX AG - A Novell company

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
