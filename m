From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH 1/4] scsi: aacraid: remove AAC_STAT_GOOD define
Date: Thu, 5 Jul 2018 17:42:02 +0000
Message-ID: <4cd9a8cb64dc4d8aa1e10c3b008c3ba0@microsemi.com>
References: <20180705110140.19545-1-jthumshirn@suse.de>
 <20180705110140.19545-2-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180705110140.19545-2-jthumshirn@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
List-Id: linux-scsi@vger.kernel.org


>=20
>=20
> Remove the AAC_STAT_GOOD definition and open code it in the places it was
> used.
>=20
> This will make subsequent refactoring in this area easier.
>=20
Please don't ... the definition itself was added to make refactoring easier=
.

-Dave
