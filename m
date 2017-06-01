From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v2 12/17] qla2xxx: Add ql2xiniexchg parameter
Date: Thu, 1 Jun 2017 18:31:37 +0000
Message-ID: <1283AADB-C100-4A6A-AEDD-1382454E1425@cavium.com>
References: <20170530175432.26984-1-himanshu.madhani@cavium.com>
 <20170530175432.26984-13-himanshu.madhani@cavium.com>
 <1496273335.2608.25.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0084.outbound.protection.outlook.com ([104.47.37.84]:57552
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751130AbdFASbl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Jun 2017 14:31:41 -0400
In-Reply-To: <1496273335.2608.25.camel@sandisk.com>
Content-Language: en-US
Content-ID: <BD903F3AB0F0C141B52E76625789B49D@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> On May 31, 2017, at 4:29 PM, Bart Van Assche <bart.vanassche@sandisk.com>=
 wrote:
>=20
> On Tue, 2017-05-30 at 10:54 -0700, Himanshu Madhani wrote:
>> -       "For Dual Mode (qlini_mode=3Ddual), this parameter determines "
>> -       "the percentage of exchanges/cmds FW will allocate resources "
>> -       "for Target mode.");
>> +     "For Dual Mode (qlini_mode=3Ddual), this parameter determines "
>> +     "the percentage of exchanges/cmds FW will allocate resources "
>> +     "for Target mode.");
>=20
> Hello Himanshu and Quinn,
>=20
> There are several pointless changes in this patch series like the above
> that changes indentation from 7 spaces to five spaces. Please leave such
> changes out from future patch submissions.
>=20
> Thanks,
>=20
> Bart.

Sure.

Thanks,
Himanshu=
