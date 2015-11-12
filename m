From: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 00/25] mpt3sas: Mergering mpt2sas & mpt3sas driver code
Date: Thu, 12 Nov 2015 12:02:47 -0800
Message-ID: <CAE9FiQWfVK0gG8kjUg83gWV7z1PCwq6i-PCtwc0htwNof5X8VA@mail.gmail.com>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<yq1d1vguioq.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1d1vguioq.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, James Bottomley <jejb@kernel.org>, Linux-Scsi <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com, Hannes Reinecke <hare@suse.de>, christopher.owens@avagotech.com, peter.rivera@avagotech.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 11, 2015 at 5:09 PM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Sreekanth" =3D=3D Sreekanth Reddy <sreekanth.reddy@avagotech.co=
m> writes:
>
> The patches in the single-module portion of the series did not compil=
e
> individually and I gave up untangling them. They were fundamentally t=
oo
> intertwined and I squashed them into one commit. Since it's mostly
> boilerplate stuff it should not matter too much from a bisection
> perspective.

on opensuse 13.1 gcc
gcc --version
gcc (SUSE Linux) 4.8.1 20130909 [gcc-4_8-branch revision 202388]

got:

In file included from drivers/scsi/mpt3sas/mpt3sas_scsih.c:59:0:
drivers/scsi/mpt3sas/mpt3sas_scsih.c: In function =E2=80=98_scsih_io_do=
ne=E2=80=99:
drivers/scsi/mpt3sas/mpt3sas_base.h:1414:1: error: inlining failed in
call to always_inline =E2=80=98mpt3sas_scsi_direct_io_get=E2=80=99: fun=
ction body not
available
 mpt3sas_scsi_direct_io_get(struct MPT3SAS_ADAPTER *ioc, u16 smid);
 ^
drivers/scsi/mpt3sas/mpt3sas_scsih.c:4448:32: error: called from here
  if (mpt3sas_scsi_direct_io_get(ioc, smid) &&
                                ^
In file included from drivers/scsi/mpt3sas/mpt3sas_scsih.c:59:0:
drivers/scsi/mpt3sas/mpt3sas_base.h:1416:1: error: inlining failed in
call to always_inline =E2=80=98mpt3sas_scsi_direct_io_set=E2=80=99: fun=
ction body not
available
 mpt3sas_scsi_direct_io_set(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8
direct_io);
 ^
drivers/scsi/mpt3sas/mpt3sas_scsih.c:4454:29: error: called from here
   mpt3sas_scsi_direct_io_set(ioc, smid, 0);
