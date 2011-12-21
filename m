From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH 1/1][RESEND] Staging: hv: storvsc: Move the storage
 driver out of the staging area
Date: Wed, 21 Dec 2011 00:42:52 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E0481B286840@TK5EX14MBXC122.redmond.corp.microsoft.com>
References: <1324407064-16875-1-git-send-email-kys@microsoft.com>
 <CAA9_cmf2RQapBD3th-RAhhTBB64N9ChKNFNXz0PEZJexeQUoqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:4970
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753485Ab1LUAm6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Dec 2011 19:42:58 -0500
In-Reply-To: <CAA9_cmf2RQapBD3th-RAhhTBB64N9ChKNFNXz0PEZJexeQUoqw@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>, "ohering@suse.com" <ohering@suse.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On B=
ehalf Of
> Dan Williams
> Sent: Tuesday, December 20, 2011 6:06 PM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; ohering@=
suse.com;
> James.Bottomley@hansenpartnership.com; hch@infradead.org; linux-
> scsi@vger.kernel.org
> Subject: Re: [PATCH 1/1][RESEND] Staging: hv: storvsc: Move the stora=
ge driver
> out of the staging area
>=20
> On Tue, Dec 20, 2011 at 10:51 AM, K. Y. Srinivasan <kys@microsoft.com=
> wrote:
> > The storage driver (storvsc_drv.c) handles all block storage device=
s
> > assigned to Linux guests hosted on Hyper-V. This driver has been in=
 the
> > staging tree for a while and this patch moves it out of the staging=
 area.
> > As per Greg's recommendation, this patch makes no changes to the st=
aging/hv
> > directory. Once the driver moves out of staging, we will cleanup th=
e
> > staging/hv directory.
> >
> > This patch includes all the patches that I have sent against the st=
aging/hv
> > tree to address the comments I have gotten to date on this storage =
driver.
> > Greg has already applied all these patches to the staging tree.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> > =A0drivers/scsi/Kconfig =A0 =A0 =A0 | =A0 =A07 +
> > =A0drivers/scsi/Makefile =A0 =A0 =A0| =A0 =A03 +
> > =A0drivers/scsi/storvsc_drv.c | 1586
> ++++++++++++++++++++++++++++++++++++++++++++
> > =A03 files changed, 1596 insertions(+), 0 deletions(-)
> > =A0create mode 100644 drivers/scsi/storvsc_drv.c
>=20
> Shouldn't this diffstat be something like the following?
>=20
>  drivers/scsi/Kconfig                       |    7 +
>  drivers/scsi/Makefile                      |    3 +
>  drivers/{staging/hv =3D> scsi}/storvsc_drv.c |  310 ++++++++++++++++=
+++---------
>  3 files changed, 218 insertions(+), 102 deletions(-)
>  rename drivers/{staging/hv =3D> scsi}/storvsc_drv.c (87%)

As per Greg's suggestion, this patch does not remove the driver from
the staging tree. Once the driver lands in the correct directory, we wi=
ll
remove the driver from the staging directory.

Regards,

K. Y

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
