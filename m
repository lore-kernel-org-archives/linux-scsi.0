From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v2 13/17] qla2xxx: Remove redundant code
Date: Thu, 1 Jun 2017 18:33:43 +0000
Message-ID: <1E552265-64D2-4E6D-9E6B-787DF447766B@cavium.com>
References: <20170530175432.26984-1-himanshu.madhani@cavium.com>
 <20170530175432.26984-14-himanshu.madhani@cavium.com>
 <1496273866.2608.27.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0053.outbound.protection.outlook.com ([104.47.36.53]:45280
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751130AbdFASdq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Jun 2017 14:33:46 -0400
In-Reply-To: <1496273866.2608.27.camel@sandisk.com>
Content-Language: en-US
Content-ID: <B6C8E8C51972414AA61A41C98498EE99@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> On May 31, 2017, at 4:37 PM, Bart Van Assche <bart.vanassche@sandisk.com>=
 wrote:
>=20
> On Tue, 2017-05-30 at 10:54 -0700, Himanshu Madhani wrote:
>> The reason for hard coding LUN ID to 0 is that, from the FC
>> protocol perspective, ABTS does not have any knowledge of
>> LUN ID. So, there is no reason for qla2xxx driver to
>> manufacture the LUN ID.
>=20
> Sorry but I think this is completely wrong. Are you aware that
> target_submit_tmr() performs an exact match on the LUN specified as the f=
ourth
> argument? This patch will cause ABTS requests to be ignored that apply to
> commands that have been submitted to another LUN than LUN 0.
>=20
> Please note that I had proposed a better approach three months ago on the
> target-devel mailing list and that I'm still waiting for someone from Cav=
ium to
> review these patches:
> * [PATCH v6 09/33] target: Make it possible to specify I_T nexus for SCSI
>   abort (http://www.spinics.net/lists/target-devel/msg14534.html).
> * [PATCH v6 10/33] tcm_qla2xxx: Let the target core look up the LUN of th=
e
>   aborted cmd (http://www.spinics.net/lists/target-devel/msg14563.html).
>=20
> Bart.

We will drop this patch from current series and will look at the alternativ=
es you have posted.

Thanks,
- Himanshu
