From: Song Liu <songliubraving@fb.com>
Subject: Re: [RFC v2 0/2] generate uevent for SCSI sense code
Date: Thu, 1 Jun 2017 16:50:53 +0000
Message-ID: <48F3810D-7189-4306-AD76-8E27C1B2D5E5@fb.com>
References: <20170518181456.1955523-1-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40881 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751432AbdFAQvF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2017 12:51:05 -0400
In-Reply-To: <20170518181456.1955523-1-songliubraving@fb.com>
Content-Language: en-US
Content-ID: <359ABD1B7F89B944B78A3F8DE950F670@namprd15.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>, Benjamin Block <bblock@linux.vnet.ibm.com>, "emilne@redhat.com" <emilne@redhat.com>


> On May 18, 2017, at 11:14 AM, Song Liu <songliubraving@fb.com> wrote:
>=20
> This change is to follow up our discussion on event log for media
> management during LSF/MM 2017.
>=20
> I have included feedbacks from Hannes Reinecke, Ewan D. Milne, and
> Benjamin Block.
>=20
> Please kindly let me know your thoughts on this.
>=20
> Thanks,
> Song
>=20
> Song Liu (2):
>  scsi: generate uevent for SCSI sense code
>  scsi: add rate limit to scsi sense code uevent
>=20
> drivers/scsi/Kconfig       | 14 +++++++++++
> drivers/scsi/scsi_error.c  | 58 +++++++++++++++++++++++++++++++++++++++++=
+++++
> drivers/scsi/scsi_lib.c    | 58 +++++++++++++++++++++++++++++++++++++++++=
++++-
> drivers/scsi/scsi_scan.c   |  4 ++++
> drivers/scsi/scsi_sysfs.c  | 51 ++++++++++++++++++++++++++++++++++++++++
> include/scsi/scsi_common.h |  6 +++++
> include/scsi/scsi_device.h | 37 ++++++++++++++++++++++++++++-
> 7 files changed, 226 insertions(+), 2 deletions(-)
>=20
> --
> 2.9.3

Dear Hannes, James, Benjamin, and Ewan,=20

Could you please share your feedback on this version of the RFC? Does it=20
need major changes?

Thanks,
Song
