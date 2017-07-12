From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH v2 01/15] qla2xxx: Combine Active command arrays.
Date: Wed, 12 Jul 2017 04:41:06 +0000
Message-ID: <E92CB6CC-9E42-441B-B64E-387437F52526@cavium.com>
References: <20170614034730.15428-1-himanshu.madhani@cavium.com>
 <20170614034730.15428-2-himanshu.madhani@cavium.com>
 <1499816619.2586.53.camel@wdc.com>
 <1499819962.30046.8.camel@haakon3.daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0062.outbound.protection.outlook.com ([104.47.38.62]:4224
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750705AbdGLElL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Jul 2017 00:41:11 -0400
In-Reply-To: <1499819962.30046.8.camel@haakon3.daterainc.com>
Content-Language: en-US
Content-ID: <134918B8B031E34DB7C163AF1FB9ED6F@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>

Hi Bart,

> On Jul 11, 2017, at 5:39 PM, Nicholas A. Bellinger <nab@linux-iscsi.org> =
wrote:
>=20
> On Tue, 2017-07-11 at 23:43 +0000, Bart Van Assche wrote:
>> On Tue, 2017-06-13 at 20:47 -0700, Himanshu Madhani wrote:
>>> typedef struct srb {
>>> +	/*
>>> +	 * Do not move cmd_type field, it needs to
>>> +	 * line up with qla_tgt_cmd->cmd_type
>>> +	 */
>>> +	uint8_t cmd_type;
>>> +	uint8_t pad[3];
>>=20
>> Hello Himanshu,
>>=20
>> Had I understood correctly that you had promised to rework the command
>> array merging such that a union is used instead of requiring certain
>> fields to be present at certain offsets (see also
>> https://www.spinics.net/lists/target-devel/msg15591.html)?
>>=20
>=20
> Yeah, as discussed previously it was not a blocker for merge.
>=20

I had mentioned in my v2 submission cover letter that we will submit new pa=
tch to
address your review comment.=20

Since we are in merge window right now i have not posted this patch. As soo=
n as 4.13.0-rc1 is out,
i will submit patch addressing your review comment.=20

Thanks,
- Himanshu
