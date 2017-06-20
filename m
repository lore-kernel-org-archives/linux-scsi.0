From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 1/6] qla2xxx: Add FC-NVMe port discovery and PRLI handling
Date: Tue, 20 Jun 2017 04:27:03 +0000
Message-ID: <B1E2622E-354A-40CE-B4BF-0CBAC2D1F204@cavium.com>
References: <20170616224744.3681-1-himanshu.madhani@cavium.com>
 <20170616224744.3681-2-himanshu.madhani@cavium.com>
 <9df75431-74d4-20a1-4a5c-464f09345812@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0067.outbound.protection.outlook.com ([104.47.34.67]:31376
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750772AbdFTE1H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Jun 2017 00:27:07 -0400
In-Reply-To: <9df75431-74d4-20a1-4a5c-464f09345812@broadcom.com>
Content-Language: en-US
Content-ID: <999F2693E91F274793864FC89E4BBEEC@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "giridhar.malaval@cavium.com" <giridhar.malaval@cavium.com>, "Trapp, Darren" <Darren.Trapp@cavium.com>


> On Jun 19, 2017, at 1:26 PM, James Smart <james.smart@broadcom.com> wrote=
:
>=20
> On 6/16/2017 3:47 PM, Himanshu Madhani wrote:
>>    /* FCP-4 types */
>>  #define FC4_TYPE_FCP_SCSI	0x08
>> +#define FC4_TYPE_NVME		0x28
>>  #define FC4_TYPE_OTHER		0x0
>>  #define FC4_TYPE_UNKNOWN	0xff
>=20
> please use the types from include/uapi/scsi/fc/fc_fs.h

Sure.
