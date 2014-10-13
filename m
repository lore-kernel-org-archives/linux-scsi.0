From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 8/8] IB/srp: Add multichannel support
Date: Mon, 13 Oct 2014 10:52:18 +0200
Message-ID: <543B92C2.1090606@acm.org>
References: <541C27BF.6070609@acm.org> <541C28E0.7010705@acm.org> <5421A093.1070203@dev.mellanox.co.il> <5433E1B5.1030103@acm.org> <543B8AB0.1090704@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <543B8AB0.1090704-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/13/14 10:17, Sagi Grimberg wrote:
> On 10/7/2014 3:51 PM, Bart Van Assche wrote:
>> On 09/23/14 18:32, Sagi Grimberg wrote:
>>> Since you don't seem to negotiate/declare multichannel with the target,
>>> did you test this code with some target implementations other than SCST
>>> that happen to be out there?
>>
>> (replying to an e-mail of two weeks ago)
>>
>> I have just verified that the multichannel code in this patch series
>> works fine in combination with the upstream SRP target driver.
>
> Working as in single channel mode? or multichannel mode?

Hello Sagi,

In my e-mail I was referring to multichannel mode.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
