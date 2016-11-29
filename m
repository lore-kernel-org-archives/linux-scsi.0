From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 1/2] SRP transport: Move queuecommand() wait code to SCSI
 core
Date: Tue, 29 Nov 2016 14:59:37 +0000
Message-ID: <BLUPR02MB16836EF63187DE03E7F1DD77818D0@BLUPR02MB1683.namprd02.prod.outlook.com>
References: <39d8cb23-0406-e8c3-6e3a-a467ebe41470@sandisk.com>
 <649cb037-3196-df4d-0d31-47f040ce44a2@sandisk.com>
 <0187d160-5985-32c4-95c0-466c4f09bdf9@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0057.outbound.protection.outlook.com ([104.47.32.57]:7296
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933730AbcK2O7k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Nov 2016 09:59:40 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Max Gurtovoy <maxg@mellanox.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>

On 11/25/16 15:21, Max Gurtovoy wrote:=0A=
> On 11/23/2016 2:17 AM, Bart Van Assche wrote:=0A=
>> +=0A=
>> +/**=0A=
>> + * scsi_wait_for_queuecommand() - wait for ongoing queuecommand() calls=
=0A=
>> + * @shost: SCSI host pointer.=0A=
>=0A=
> the arg is sdev.=0A=
=0A=
Good catch.=0A=
=0A=
Martin, do you want me to repost this patch or do you want me to post a =0A=
fix-up patch?=0A=
=0A=
Bart.=0A=
=0A=
