From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] scsi: avoid a permanent stop of the scsi device's request
 queue
Date: Wed, 7 Dec 2016 02:45:46 +0000
Message-ID: <BLUPR02MB168364C1D3A8A2C7CF367D5481850@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <1481015547-23474-1-git-send-email-fangwei1@huawei.com>
 <BLUPR02MB16838CCF3E631720279B921781820@BLUPR02MB1683.namprd02.prod.outlook.com>
 <584763FB.9010602@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0062.outbound.protection.outlook.com ([104.47.32.62]:57312
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751762AbcLGCpt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Dec 2016 21:45:49 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "tyasui@redhat.com" <tyasui@redhat.com>

On 12/06/16 17:21, Wei Fang wrote:=0A=
> The state of the scsi device first is changed to SDEV_BLOCK in=0A=
> scsi_add_lun() as you mentioned, then it will be changed to SDEV_RUNNING=
=0A=
> in scsi_sysfs_add_sdev().=0A=
=0A=
Hello Wei,=0A=
=0A=
The purpose of the scsi_device_set_state(sdev, SDEV_RUNNING) call in =0A=
scsi_sysfs_add_sdev() is to change the device state from SDEV_CREATED =0A=
into SDEV_RUNNING. Have you tried to modify scsi_sysfs_add_sdev() such =0A=
that it only changes the device state into SDEV_RUNNING if the current =0A=
state is SDEV_CREATED and also such that it changes SDEV_CREATED_BLOCK =0A=
into SDEV_BLOCK?=0A=
=0A=
Thanks,=0A=
=0A=
Bart.=0A=
