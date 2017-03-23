From: "Satish Kharat (satishkh)" <satishkh@cisco.com>
Subject: RE: [PATCH 1/1] fnic: Adding Check Condition counter to misc
 fnicstats
Date: Thu, 23 Mar 2017 00:03:28 +0000
Message-ID: <29e530689cd247b9a6ab377fc5f71dfd@XCH-RCD-012.cisco.com>
References: <1488327344-8817-1-git-send-email-satishkh@cisco.com>
 <yq14lzcqt0o.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:9304 "EHLO
        rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932530AbdCWADb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2017 20:03:31 -0400
In-Reply-To: <yq14lzcqt0o.fsf@oracle.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>

Hi Martin,
 Apologies for the delay. I was not able to verify this because of another =
fnic issue blocking this test. Just now submitted a fix for that 'fnic issu=
e' (in the patch =3D> [PATCH 1/1] fnic: bug fix for fip.fip_subcode in fnic=
_fcoe_send_vlan_req)

Did some quick verification and basic IO test, this patch looks good.

Thanks,
Satish Kharat

-----Original Message-----
From: Martin K. Petersen [mailto:martin.petersen@oracle.com]=20
Sent: Wednesday, March 01, 2017 7:04 PM
To: Satish Kharat (satishkh) <satishkh@cisco.com>
Cc: linux-scsi@vger.kernel.org; Sesidhar Baddela (sebaddel) <sebaddel@cisco=
.com>
Subject: Re: [PATCH 1/1] fnic: Adding Check Condition counter to misc fnics=
tats

>>>>> "Satish" =3D=3D Satish Kharat <satishkh@cisco.com> writes:

Satish,

Satish> Just a simple counter of number of check conditions encountered=20
Satish> on that host.

Please test and review the following:

	https://patchwork.kernel.org/patch/9549777/

Thank you!

--=20
Martin K. Petersen	Oracle Linux Engineering
