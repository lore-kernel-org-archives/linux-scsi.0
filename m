From: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Subject: Re: [PATCH 21/43] qla2xxx: Remove calling cancel_work_sync()
Date: Wed, 20 Dec 2017 21:41:20 +0000
Message-ID: <7B62A4A1-0A14-43E3-834D-7C0908FED0DA@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
 <20171220065644.21511-22-himanshu.madhani@cavium.com>
 <1513789005.2603.30.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0072.outbound.protection.outlook.com ([104.47.40.72]:56928
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754502AbdLTVlW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 16:41:22 -0500
In-Reply-To: <1513789005.2603.30.camel@wdc.com>
Content-Language: en-US
Content-ID: <D27AC467C41B344EA3AC86ADDD0B7BF8@namprd07.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


> On Dec 20, 2017, at 10:56 AM, Bart Van Assche <bart.vanassche@wdc.com> wr=
ote:
>=20
> On Tue, 2017-12-19 at 22:56 -0800, Himanshu Madhani wrote:
>> @@ -1234,8 +1234,6 @@ void qlt_schedule_sess_for_deletion(struct fc_port=
 *sess,
>> 	ql_dbg(ql_dbg_tgt, sess->vha, 0xe001,
>> 	    "Scheduling sess %p for deletion\n", sess);
>>=20
>> -	/* use cancel to push work element through before re-queue */
>> -	cancel_work_sync(&sess->del_work);
>> 	INIT_WORK(&sess->del_work, qla24xx_delete_sess_fn);
>> 	queue_work(sess->vha->hw->wq, &sess->del_work);
>=20
> Why had this cancel_work_sync() call been introduced in
> qlt_schedule_sess_for_deletion() and why do you think it is safe to remov=
e
> this call? Both questions should have been answered in the patch descript=
ion.
>=20
> Thanks,
>=20
> Bart.

I will drop this patch from current series and will update commit message w=
ith details
as suggested and submit in next series.

Thanks,
- Himanshu
