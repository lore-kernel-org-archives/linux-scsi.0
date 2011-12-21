From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1][RESEND] Staging: hv: storvsc: Move the storage
 driver out of the staging area
Date: Wed, 21 Dec 2011 15:04:52 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B293651@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1324407064-16875-1-git-send-email-kys@microsoft.com>
	<CAA9_cmf2RQapBD3th-RAhhTBB64N9ChKNFNXz0PEZJexeQUoqw@mail.gmail.com>
	<6E21E5352C11B742B20C142EB499E0481B286840@TK5EX14MBXC122.redmond.corp.microsoft.com>
 <CABE8wwsat+JGLiKpu_70bxZQAYegdrcsow=9XXBabwgWUgBT4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:57130
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751606Ab1LUPFT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Dec 2011 10:05:19 -0500
In-Reply-To: <CABE8wwsat+JGLiKpu_70bxZQAYegdrcsow=9XXBabwgWUgBT4Q@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Williams, Dan J [mailto:dan.j.williams@intel.com]
> Sent: Tuesday, December 20, 2011 8:33 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; ohering@suse.com;
> James.Bottomley@hansenpartnership.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1][RESEND] Staging: hv: storvsc: Move the stora=
ge driver
> out of the staging area
>=20
> On Tue, Dec 20, 2011 at 4:42 PM, KY Srinivasan <kys@microsoft.com> wr=
ote:
> >
> >
> >> -----Original Message-----
> >> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] O=
n Behalf
> Of
> >> Dan Williams
> >> Sent: Tuesday, December 20, 2011 6:06 PM
> >> To: KY Srinivasan
> >> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> >> devel@linuxdriverproject.org; virtualization@lists.osdl.org;
> ohering@suse.com;
> >> James.Bottomley@hansenpartnership.com; hch@infradead.org; linux-
> >> scsi@vger.kernel.org
> >> Subject: Re: [PATCH 1/1][RESEND] Staging: hv: storvsc: Move the st=
orage
> driver
> >> out of the staging area
> >>
> >> On Tue, Dec 20, 2011 at 10:51 AM, K. Y. Srinivasan <kys@microsoft.=
com>
> wrote:
> >> > The storage driver (storvsc_drv.c) handles all block storage dev=
ices
> >> > assigned to Linux guests hosted on Hyper-V. This driver has been=
 in the
> >> > staging tree for a while and this patch moves it out of the stag=
ing area.
> >> > As per Greg's recommendation, this patch makes no changes to the
> staging/hv
> >> > directory. Once the driver moves out of staging, we will cleanup=
 the
> >> > staging/hv directory.
> >> >
> >> > This patch includes all the patches that I have sent against the=
 staging/hv
> >> > tree to address the comments I have gotten to date on this stora=
ge driver.
> >> > Greg has already applied all these patches to the staging tree.
> >> >
> >> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> >> > ---
> >> > =A0drivers/scsi/Kconfig =A0 =A0 =A0 | =A0 =A07 +
> >> > =A0drivers/scsi/Makefile =A0 =A0 =A0| =A0 =A03 +
> >> > =A0drivers/scsi/storvsc_drv.c | 1586
> >> ++++++++++++++++++++++++++++++++++++++++++++
> >> > =A03 files changed, 1596 insertions(+), 0 deletions(-)
> >> > =A0create mode 100644 drivers/scsi/storvsc_drv.c
> >>
> >> Shouldn't this diffstat be something like the following?
> >>
> >> =A0drivers/scsi/Kconfig =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 | =A0 =A07 +
> >> =A0drivers/scsi/Makefile =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
| =A0 =A03 +
> >> =A0drivers/{staging/hv =3D> scsi}/storvsc_drv.c | =A0310 +++++++++=
++++++++++------
> ---
> >> =A03 files changed, 218 insertions(+), 102 deletions(-)
> >> =A0rename drivers/{staging/hv =3D> scsi}/storvsc_drv.c (87%)
> >
> > As per Greg's suggestion, this patch does not remove the driver fro=
m
> > the staging tree. Once the driver lands in the correct directory, w=
e will
> > remove the driver from the staging directory.
>=20
> Ah, ok, so the patch can be accepted in parallel with the staging upd=
ate.
>=20
> I still think it wouldn't hurt to show what:
>=20
> git diff --stat --summary -M
>=20
> ...is after the removal of the version in drivers/staging/hv/ to
> quickly show that git agrees that the versions are indeed identical,
> but no big deal.

Once I hear from James/other  scsi maintainers about their willingness =
to take this=20
driver,  I will send out the summary diff.

Regards,

K. Y

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
