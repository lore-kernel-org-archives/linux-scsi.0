From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [LSF/MM TOPIC] Reducing the SRP initiator failover time
Date: Fri, 8 Feb 2013 11:24:35 +0200
Message-ID: <5114C453.7010904@mellanox.com>
References: <510BC68A.90708@acm.org> <CAJZOPZJeCdkJ0xfK0kxic9jfz5A5ddw7TSWXe51yuO6bYTk4ag@mail.gmail.com> <BB97625FCF082447AC2B11418FF02044A6E9E9C5@MTLDAG01.mtl.com> <51142DE9.30900@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51142DE9.30900-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, lsf-pc-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 2/8/2013 12:42 AM, Vu Pham wrote:
>
>>
>>
>> It is known that it takes about two to three minutes before the 
>> upstream SRP initiator fails over from a failed path to a working 
>> path. This is not only considered longer than acceptable but is also 
>> longer than other Linux SCSI initiators (e.g. iSCSI and FC). Progress 
>> so far with improving the fail-over SRP initiator has been slow. This 
>> is because the discussion about candidate patches occurred at two 
>> different levels: not only the patches itself were discussed but also 
>> the approach that should be followed. That last aspect is easier to 
>> discuss in a meeting than over a mailing list. Hence the proposal to 
>> discuss SRP initiator failover behavior during the LSF/MM summit. The 
>> topics that need further discussion are:
>> * If a path fails, remove the entire SCSI host or preserve the SCSI
>>   host and only remove the SCSI devices associated with that host ?
>> * Which software component should test the state of a path and should
>>   reconnect to an SRP target if a path is restored ? Should that be
>>   done by the user space process srp_daemon or by the SRP initiator
>>   kernel module ?
>> * How should the SRP initiator behave after a path failure has been
>>   detected ? Should the behavior be similar to the FC initiator with
>>   its fast_io_fail_tmo and dev_loss_tmo parameters ?
>>
>> Dave, if this topic gets accepted, I really hope you will be able to 
>> attend the LSF/MM summit.
>>
>> Bart.
>>
> Hello Bart,
>
> Thank you for taking the initiative.
> Mellanox think that this should be discussed. We'd be happy to attend.
>
> We also would like to discuss:
> * How and how fast does SRP detect a path failure besides RC error?
> * Role of srp_daemon, how often srp_daemon scan fabric for new/old 
> targets, how-to scale srp_daemon discovery, traps.
>
> -vu
Hey Bart,

I agree with Vu that this issue should be discussed. We'd be happy to 
attend.

--
Sagi
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
