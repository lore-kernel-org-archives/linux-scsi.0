Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E1BBC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 07:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbiCaHKp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 03:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbiCaHKo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 03:10:44 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A771B7579
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 00:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1648710526;
        bh=zOXy4zNL1gpCy5h9zwnD7Mqc0cgScD13ev8CzvexlOA=;
        h=X-UI-Sender-Class:Date:From:To:Subject;
        b=eXZtAjIDYJ3rEwwLokfZr4SmXQLhmW06qH5vc00cTM0YDpmx4uLTTtuXItHCNz/vg
         YlbGCF8Z1/OOf12HpwJP6MT2wXfj5eEpIL1mJYOZvngGxXFM2OV27G9wP+0a+cQ7IT
         lFXdu3abMLz8S4pcufd8MApyzibsy5IxDEXMExOI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from p100 ([92.116.186.82]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MiJVG-1oCzUG1xRe-00fOOv; Thu, 31
 Mar 2022 09:08:46 +0200
Date:   Thu, 31 Mar 2022 09:08:44 +0200
From:   Helge Deller <deller@gmx.de>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: mpt3sas_base.c:5396:40: =?utf-8?Q?warning?=
 =?utf-8?Q?=3A_array_subscript_=E2=80=98Mpi2SasIOUnitPage1=5Ft_is_partly_o?=
 =?utf-8?Q?utside_array_bounds_of_=E2=80=98unsigned_char=5B20=5D=E2=80=99?=
Message-ID: <YkVTfIpkQ6u1hHXU@p100>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Iu0fwYZM7mp0qZfzK+IDiA/i0L/2FbwVCKDf2FcdftnjSrycMBd
 VqMeaLjbWsy7CMLeTUUyR/+LnC7IlQoDHnWEEE8QgcSTfK3kknRnapuypZYp1z0r2vdfUOC
 q4nWaTIVm5TPr4qnTHUj7sAlUCMQcgwhXcZClNiNtG2MRhWzRDoABr27kPK420+FU8QIhKX
 C6RbRSTsXr4MI43z0mfoQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:4ZP4E+SllNQ=:MCk2cDY+A7ML+jZj/RCiai
 DQKP0a5h1XBMrCp3vZ8AwF9nubCFHIQmpoKK6fjas6Jc3MBQQzyynB8g3wYbDpirep1tX0MZ7
 puvwR34/jfCf61O8RxeiDH9GjNDQuC7DzophcyzfYktT3r/Vv9ISgat+id8vCJUONQ6/xgfRx
 F9KzsoE62L0EgOgjO0IMsh+gxepd86Jq3ppiy8LlcIriKxmrhdqWq+SutKQgynEiMyWIP6gWW
 FdwjgKyM9qwkv+gQnnvlRdiRsx3GVNps+No5sgZEnfkLe6KeI7TNJSI/NsnjZe8sCZTl7ph33
 9Lkrx+9b5uSC3WmCJKzONeioJ7dlFRthN0VuECXB8sTnuuHErZJtvWHSHsGbEVwyD+bEs5cJN
 IVMsD5iI+nuL8WtFasreZvc5hyEbMJQ3rEiwWvUJGsCqCRqSoRT93i/XUJqLM4v1ZbDFMJwu2
 4lJgw84exDO3JeUUjIpspWUxjtf4UxdEwfmgnA+QyNcxKUnvESyNCWeZDv1/96xZZB2lmDMjc
 ZOr8/zV9dpfQ7UsHwvcbH5A4jXK32jBRd93JrYAd3Xk01xCOP8mWow4SCXWDHA7vNSHv2XdFE
 TLxsTCaJhfAL3U1Wpos2PrlseqBFdyMg6T8bVYyv8EkdD6I5gT7jCpugvb2htuuM8EAHMZVzY
 gsde+GaxjYAwGROtXG59YwuKbo8mLYN16LIYBG+hYPPZ7ax0YcrQHirr1drOeAwB2gBHqocKf
 oyGu3tUjpKsmYL8Gn7SbQeqdZbS3sF1+R1ATTNVJAK15aFIp2DHqrfFVpIbW32yjfVI2PoPlI
 ydsy14ihlvj1wdHY/WmtR45EQNpUgwOD0zS3nAEaUujqHFqIYxyJBlO2eYRELIoRe56LAtt4r
 xnMeVZ9A4f2qxiYllf1oEwn7TER4W4sQC9d0nb5MtIn50Xh7MfR59fzxGnoi3uNIGSovfjmeZ
 yW17j0tb1Cx2mf256KB3lpbQzh0rA3Bni38is7YW+hssnjOk35uoG0wCQ8Zz1H80+NLI7rABU
 ScKuHHHxkyMX687srDBqCC03Zwq6TQqRfHu3jEoid6n08CVoEsvq9XDbtQeql3706xAJYd5xa
 ZKvFWYUiwoRztU=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When compiling current kernel git head for the parisc platform I face comp=
iler warnings:

  CC      drivers/scsi/mpt3sas/mpt3sas_base.o
In file included from linux/include/linux/swab.h:5,
                 from linux/include/uapi/linux/byteorder/big_endian.h:14,
                 from linux/include/linux/byteorder/big_endian.h:5,
                 from linux/arch/parisc/include/uapi/asm/byteorder.h:5,
                 from linux/arch/parisc/include/asm/bitops.h:11,
                 from linux/include/linux/bitops.h:33,
                 from linux/include/linux/kernel.h:22,
                 from linux/drivers/scsi/mpt3sas/mpt3sas_base.c:46:
linux/drivers/scsi/mpt3sas/mpt3sas_base.c: In function =E2=80=98_base_make=
_ioc_operational=E2=80=99:
linux/drivers/scsi/mpt3sas/mpt3sas_base.c:5396:40: warning: array subscrip=
t =E2=80=98Mpi2SasIOUnitPage1_t {aka struct _MPI2_CONFIG_PAGE_SASIOUNIT_1}=
[0]=E2=80=99 is partly outside array bounds of =E2=80=98unsigned char[20]=
=E2=80=99 [-Warray-bounds]
 5396 |             (le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth)) ?
linux/include/uapi/linux/swab.h:105:39: note: in definition of macro =E2=
=80=98__swab16=E2=80=99
  105 |         (__builtin_constant_p((__u16)(x)) ?     \
      |                                       ^
linux/include/linux/byteorder/generic.h:91:21: note: in expansion of macro=
 =E2=80=98__le16_to_cpu=E2=80=99
   91 | #define le16_to_cpu __le16_to_cpu
      |                     ^~~~~~~~~~~~~
linux/drivers/scsi/mpt3sas/mpt3sas_base.c:5396:14: note: in expansion of m=
acro =E2=80=98le16_to_cpu=E2=80=99
 5396 |             (le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth)) ?
      |              ^~~~~~~~~~~
linux/drivers/scsi/mpt3sas/mpt3sas_base.c:5382:26: note: referencing an ob=
ject of size 20 allocated by =E2=80=98kzalloc=E2=80=99
 5382 |         sas_iounit_pg1 =3D kzalloc(sz, GFP_KERNEL);
      |                          ^~~~~~~~~~~~~~~~~~~~~~~
In file included from linux/include/linux/swab.h:5,
                 from linux/include/uapi/linux/byteorder/big_endian.h:14,
                 from linux/include/linux/byteorder/big_endian.h:5,
                 from linux/arch/parisc/include/uapi/asm/byteorder.h:5,
                 from linux/arch/parisc/include/asm/bitops.h:11,
                 from linux/include/linux/bitops.h:33,
                 from linux/include/linux/kernel.h:22,
                 from linux/drivers/scsi/mpt3sas/mpt3sas_base.c:46:
linux/drivers/scsi/mpt3sas/mpt3sas_base.c:5400:40: warning: array subscrip=
t =E2=80=98Mpi2SasIOUnitPage1_t {aka struct _MPI2_CONFIG_PAGE_SASIOUNIT_1}=
[0]=E2=80=99 is partly outside array bounds of =E2=80=98unsigned char[20]=
=E2=80=99 [-Warray-bounds]
 5400 |             (le16_to_cpu(sas_iounit_pg1->SASNarrowMaxQueueDepth)) =
?
linux/include/uapi/linux/swab.h:105:39: note: in definition of macro =E2=
=80=98__swab16=E2=80=99
  105 |         (__builtin_constant_p((__u16)(x)) ?     \
      |                                       ^
linux/include/linux/byteorder/generic.h:91:21: note: in expansion of macro=
 =E2=80=98__le16_to_cpu=E2=80=99
   91 | #define le16_to_cpu __le16_to_cpu
      |                     ^~~~~~~~~~~~~
linux/drivers/scsi/mpt3sas/mpt3sas_base.c:5400:14: note: in expansion of m=
acro =E2=80=98le16_to_cpu=E2=80=99
 5400 |             (le16_to_cpu(sas_iounit_pg1->SASNarrowMaxQueueDepth)) =
?
      |              ^~~~~~~~~~~
linux/drivers/scsi/mpt3sas/mpt3sas_base.c:5382:26: note: referencing an ob=
ject of size 20 allocated by =E2=80=98kzalloc=E2=80=99
 5382 |         sas_iounit_pg1 =3D kzalloc(sz, GFP_KERNEL);
      |                          ^~~~~~~~~~~~~~~~~~~~~~~
linux/drivers/scsi/mpt3sas/mpt3sas_base.c:5403:43: warning: array subscrip=
t =E2=80=98Mpi2SasIOUnitPage1_t {aka struct _MPI2_CONFIG_PAGE_SASIOUNIT_1}=
[0]=E2=80=99 is partly outside array bounds of =E2=80=98unsigned char[20]=
=E2=80=99 [-Warray-bounds]
 5403 |         ioc->max_sata_qd =3D (sas_iounit_pg1->SATAMaxQDepth) ?
      |                            ~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~
linux/drivers/scsi/mpt3sas/mpt3sas_base.c:5382:26: note: referencing an ob=
ject of size 20 allocated by =E2=80=98kzalloc=E2=80=99
 5382 |         sas_iounit_pg1 =3D kzalloc(sz, GFP_KERNEL);
      |                          ^~~~~~~~~~~~~~~~~~~~~~~


Helge
