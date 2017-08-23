From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH 0/2] generate uevent for SCSI sense code
Date: Wed, 23 Aug 2017 19:13:55 +0000
Message-ID: <8AD80D6A-54F0-4FBF-BF7C-47E1958EE04C@fb.com>
References: <20170721225732.311745-1-songliubraving@fb.com>
 <98B7207C-AF0B-4157-A417-68387E634FE2@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36148 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932458AbdHWTOK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Aug 2017 15:14:10 -0400
In-Reply-To: <98B7207C-AF0B-4157-A417-68387E634FE2@fb.com>
Content-Language: en-US
Content-ID: <AE3BC984188C774CB931670A0C45412E@namprd15.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "bblock@linux.vnet.ibm.com" <bblock@linux.vnet.ibm.com>, "emilne@redhat.com" <emilne@redhat.com>, "jthumshirn@suse.de" <jthumshirn@suse.de>

Dear Hannes and James,=20

Could you please kindly review this patch and let me know what do we=20
need to move forward with this?

Thanks and Regards,
Song


> On Aug 4, 2017, at 10:18 AM, Song Liu <songliubraving@fb.com> wrote:
>=20
> Hi all,=20
>=20
> Could you please share your feedback on this version of the change?=20
>=20
> Thanks in advance,
> Song
>=20
>>> On 7/21/17, 3:58 PM, "Song Liu" <songliubraving@fb.com> wrote:
>=20
>    This change is to follow up our discussion on event log for media
>    management during LSF/MM 2017.
>=20
>    Changes from RFC v3:
>      Incorporate feedback by Johannes Thumshirn
>=20
>    Thanks,
>    Song
>=20
>    Song Liu (2):
>      scsi: generate uevent for SCSI sense code
>      scsi: add rate limit to scsi sense code uevent
>=20
>     drivers/scsi/Kconfig       | 14 +++++++++++
>     drivers/scsi/hosts.c       |  4 ++++
>     drivers/scsi/scsi_error.c  | 58 +++++++++++++++++++++++++++++++++++++=
+++++++++
>     drivers/scsi/scsi_lib.c    | 58 +++++++++++++++++++++++++++++++++++++=
++++++++-
>     drivers/scsi/scsi_sysfs.c  | 51 +++++++++++++++++++++++++++++++++++++=
+++
>     include/scsi/scsi_common.h |  6 +++++
>     include/scsi/scsi_device.h | 27 ++++++++++++++++++++-
>     include/scsi/scsi_host.h   | 13 +++++++++++
>     8 files changed, 229 insertions(+), 2 deletions(-)
>=20
>    --
>    2.9.3
>=20
>=20
