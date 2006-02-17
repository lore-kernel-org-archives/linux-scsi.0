From: Hannes Reinecke <hare@suse.de>
Subject: Re: [Bugme-new] [Bug 6080] New: New Megaraid Module Problem
Date: Fri, 17 Feb 2006 10:21:46 +0100
Message-ID: <43F595AA.5090603@suse.de>
References: <9738BCBE884FDB42801FAD8A7769C265142091@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:16096 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S932590AbWBQJVy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Feb 2006 04:21:54 -0500
In-Reply-To: <9738BCBE884FDB42801FAD8A7769C265142091@NAMAIL1.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Cc: "Ju, Seokmann" <Seokmann.Ju@engenio.com>, Andrew Morton <akpm@osdl.org>, "Kolli, Neela" <Neela.Kolli@engenio.com>, linux-scsi@vger.kernel.org, "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@bugzilla.kernel.org>

Ju, Seokmann wrote:
> Hi,
> On Thursday, February 16, 2006 9:36 AM Seokmann Ju wrote:
>> I've verified the 'megaraid' driver that is available on GIT=20
>> kernel (2.6.16-rc2).
>> The driver 'megaraid.ko' is working fine on the kernel.
>> However, I'm working on another issue related to this driver.=20
>> On SuSE SLES 10 (kernel 2.6.16-rc1-git3-7), the kernel claims=20
>> that the driver has loaded, but it won't detect the=20
>> controller nor scan the drives.
>> Both kernel (GIT kernel and SLES10) have same 'megaraid' driver.
>> I'll update here for any progress on it.
> I've also test 'megaraid.ko' driver on latest GIT kernel 2.6.16-rc3.
> The driver works fine as expected. I've ran the basic I/O test after =
file system created on the device.
>=20
Isn't the megaraid i960 based? Then it might well be that it collides
with the generic i2o modules which are loaded previously by default.

So check whether any of those i2o modules are loaded and unload them
before continuing.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
