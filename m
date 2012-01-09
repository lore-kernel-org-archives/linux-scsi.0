From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH] scsi_dh_rdac: Fix error path
Date: Mon, 9 Jan 2012 17:13:05 -0500
Message-ID: <CAMM=eLeXa7qLMyG+njL9yuYDkUAxTNLV5eHi+y_=X+1eDVwZ_g@mail.gmail.com>
References: <1321577067-26332-1-git-send-email-richard@nod.at>
 <47D23AD8469A2B448F33C24BD7A39BD9108C7178@RTPMVEXC1-PRD.hq.netapp.com> <4EEDFBCF.4040802@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4EEDFBCF.4040802@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: "Moger, Babu" <Babu.Moger@netapp.com>, JBottomley@parallels.com, Somasundaram.Krishnasamy@lsi.com, yanling.qi@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Dec 18, 2011 at 9:42 AM, Richard Weinberger <richard@nod.at> wr=
ote:
> Am 18.11.2011 15:34, schrieb Moger, Babu:
>> Looks good to me..
>>
>>> -----Original Message-----
>>> From: Richard Weinberger [mailto:richard@nod.at]
>>> Sent: Thursday, November 17, 2011 6:44 PM
>>> To: JBottomley@parallels.com
>>> Cc: Moger, Babu; Somasundaram.Krishnasamy@lsi.com; yanling.qi@lsi.c=
om;
>>> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Richard
>>> Weinberger
>>> Subject: [PATCH] scsi_dh_rdac: Fix error path
>>>
>>> If create_singlethread_workqueue() failes, rdac_init should fail to=
o.
>>>
>>> Signed-off-by: Richard Weinberger <richard@nod.at>
>>> ---
>>> =A0drivers/scsi/device_handler/scsi_dh_rdac.c | =A0 =A02 ++
>>> =A01 files changed, 2 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c
>>> b/drivers/scsi/device_handler/scsi_dh_rdac.c
>>> index 1d31279..2802394 100644
>>> --- a/drivers/scsi/device_handler/scsi_dh_rdac.c
>>> +++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
>>> @@ -934,6 +934,8 @@ static int __init rdac_init(void)
>>> =A0 =A0 =A0if (!kmpath_rdacd) {
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0scsi_unregister_device_handler(&rdac_dh)=
;
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0printk(KERN_ERR "kmpath_rdacd creation f=
ailed.\n");
>>> +
>>> + =A0 =A0 =A0 =A0 =A0 =A0r =3D -EINVAL;
>>> =A0 =A0 =A0}
>>> =A0done:
>>> =A0 =A0 =A0return r;
>>> --
>>> 1.7.7.3
>>
>
> James,
>
> can you please pickup this patch?

James, was this the one that you said was overlooked?

In any case, please apply, and for good measure:

Acked-by: Mike Snitzer <snitzer@redhat.com>
