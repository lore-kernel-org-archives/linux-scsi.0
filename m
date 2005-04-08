From: Frederic TEMPORELLI <frederic.temporelli@bull.net>
Subject: Re: proc_name in sysfs
Date: Fri, 08 Apr 2005 09:37:46 +0200
Message-ID: <425634CA.8060603@bull.net>
References: <4253CA94.8000500@bull.net> <20050406183614.GA25370@us.ibm.com> <4254877B.4020607@torque.net> <4254D4A4.1000307@bull.net> <20050408000256.GB8300@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:35207 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S262727AbVDHHh7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2005 03:37:59 -0400
In-Reply-To: <20050408000256.GB8300@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net

Hi,

Patrick Mansfield a =E9crit :
> On Thu, Apr 07, 2005 at 08:35:16AM +0200, Frederic TEMPORELLI wrote:
>=20
>>Hi,
>>
>>
>>Sorry, no such "driver" directory in /sys/class/scsi_host/hostX/
>=20
>=20
> Doug answered that.
>=20

thx, I've just try the script and it works...
(mea culpa, I should have look in details to the symlinks)


>=20
>>>>Why do you need it?
>=20
>=20
> If you answer the above you might get better/other suggestions.

We already have scripts for getting HBAs informations, and these script=
s are=20
based on /sys/class/scsi_host/hostX/proc_name to define how to process=20
informations (we don't care about WWPN when using U320 adapter).

=3D> I'll change our scripts according to Doug's solution, this should =
be fine.

Thanks again...


--=20
=46rederic TEMPORELLI
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
