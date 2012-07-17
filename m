From: bart-LmZ/31Jx5xYUl6sPKNhdgg@public.gmane.org
Subject: Re: [PATCH 13/15] ib_srp: Allow SRP disconnect through sysfs
Date: Tue, 17 Jul 2012 14:55:42 +0200
Message-ID: <03ca6d60dd7daaf32916fd9c86664fce.squirrel@www.bartvanassche.be>
References: <5207288.nSt5MkVMpO@asus> <12137079.5Hhh1ukOmv@asus>
    <500493B4.4010303@cs.wisc.edu>
Reply-To: bart-LmZ/31Jx5xYUl6sPKNhdgg@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <500493B4.4010303-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dillowda-1Heg1YXhbW8@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

> On 03/25/2012 09:01 AM, Bart Van Assche wrote:
>> +static void srp_rport_delete(struct srp_rport *rport)
>> +{
>> +	struct srp_target_port *target = rport->lld_data;
>> +
>> +	BUG_ON(!target);
>> +
>
> I don't think this null check is needed, because below you set the
> lld_data before you call srp_rport_add which does the transport driver
> model/sysfs file addition for the rport. So I think the rport delete
> sysfs file won't show up before you set the lld_data.

Agreed. I'm fine with leaving that check out.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
