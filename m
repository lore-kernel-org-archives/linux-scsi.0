From: Alexis Bruemmer <alexisb@us.ibm.com>
Subject: Re: unable to compile aic94xx-sas-2.6.git tree kernel
Date: Wed, 20 Sep 2006 08:57:18 -0700
Message-ID: <1158767839.906.63.camel@localhost.localdomain>
References: <45112F88.6010708@1art.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:55975 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751682AbWITP5p
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Sep 2006 11:57:45 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8KFvj2c001449
	for <linux-scsi@vger.kernel.org>; Wed, 20 Sep 2006 11:57:45 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8KFviLt268942
	for <linux-scsi@vger.kernel.org>; Wed, 20 Sep 2006 09:57:44 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8KFviQL030212
	for <linux-scsi@vger.kernel.org>; Wed, 20 Sep 2006 09:57:44 -0600
In-Reply-To: <45112F88.6010708@1art.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-1?Q?V=E1clav_B=EDlek?= <v.bilek@1art.cz>
Cc: linux-scsi@vger.kernel.org

On Wed, 2006-09-20 at 14:09 +0200, V=C3=A1clav B=C3=ADlek wrote:
> Helo
>=20
> I am trying to run a supermicro X7DB3 with adaptec 9410W and 9 sata
> disks 8 on 9410W and 1 on onboard sata intel controler.
>=20
> I did a git clone of
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/aic94xx-sas-2.6.gi=
t

You will also need to include scsi-misc-2.6 from jejb's tree.

--Alexis
>=20
> but I am not able to compile it :(
>=20
> when I do make mrproper; make menuconfig -> disable modular kernel;
> enable  aic94xx, sata piix,and nic e1000 ;
> make ...
>=20
> i get :
>=20
> drivers/scsi/scsi.c: In function `scsi_device_put':
> drivers/scsi/scsi.c:880: warning: implicit declaration of function
> `module_refcount'
> .
> .
> .
> .
>   LD      drivers/built-in.o
>   GEN     .version
>   CHK     include/linux/compile.h
>   UPD     include/linux/compile.h
>   CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o(.text+0xb2be7): In function `scsi_device_put':
> : undefined reference to `module_refcount'
> drivers/built-in.o(.text+0xc7477): In function `asd_request_firmware'=
:
> : undefined reference to `request_firmware'
> make: *** [.tmp_vmlinux1] Error 1
>=20
>=20
> can anybody help me ?
>=20
> Vaclav Bilek
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
