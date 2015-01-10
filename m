From: Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM ATTEND] [LSF/MM TOPIC]
Date: Sat, 10 Jan 2015 14:41:50 +0100
Message-ID: <54B12C1E.6000504@suse.de>
References: <1420820048.3891.156.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52136 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393AbbAJNlw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2015 08:41:52 -0500
In-Reply-To: <1420820048.3891.156.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com, lsf-pc@lists.linux-foundation.org
Cc: linux-scsi@vger.kernel.org

On 01/09/2015 05:14 PM, Ewan Milne wrote:
> I'd like to attend LSF -- I am responsible for maintaining the SCSI
> subsystem at Red Hat, and in addition to resolving issues for custome=
rs
> and partners, I've been participating in upstream development for the
> past couple of years.  I have an extensive background in SCSI and OS
> development, including 15 years of working with the Linux kernel.
>=20
> I would also like to have a discussion at LSF/MM 2015 about how we co=
uld
> better handle devices whose properties change after being probed. Thi=
s
> includes:
>=20
>   - READ CAPACITY data
>   - ALUA state
>   - EMC OWNED/UNOWNED state
>   - NOT READY state
>=20
> Currently, when these properties change, we do not always handle it
> very well (e.g. multipath stops using a path if the capacity changes,
> even if it the only good path to the device...)
>=20
Hehe. I was waiting for this to pop up :-)
"Not handling it very well" is an euphemism ...

So yes, I'd definitely like to discuss this.

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
