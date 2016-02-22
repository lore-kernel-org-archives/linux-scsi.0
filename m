From: Charles Chiou <ch1102chiou@gmail.com>
Subject: Re: [Resend PATCH 3/3] scsi:stex.c Add S3/S4 support
Date: Mon, 22 Feb 2016 10:38:33 +0800
Message-ID: <56CA74A9.6040906@gmail.com>
References: <55E83F66.2060300@gmail.com> <mqd8u8nbnw5.fsf@c203.arch.suse.de>	 <56AB4BBD.2030702@gmail.com> <56B33493.80300@gmail.com> <1454585845.16206.2.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454585845.16206.2.camel@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>, JBottomley@parallels.com, grace.chang@tw.promise.com, linus.chen@tw.promise.com, victor.p@promise.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, eva.cheng@tw.promise.com
List-Id: linux-scsi@vger.kernel.org

Hi Oliver,
sure, we'll fix it at the next patch version. Thank you.
Charles

On 02/04/2016 07:37 PM, Oliver Neukum wrote:
> On Thu, 2016-02-04 at 19:22 +0800, Charles Chiou wrote:
>> +static int stex_choice_sleep_mic(pm_message_t state)
>> +{
>> +    switch (state.event) {
>> +    case PM_EVENT_SUSPEND:
>> +        return ST_S3;
>> +    case PM_EVENT_FREEZE:
>
> Why do you react to PM_EVENT_FREEZE at all?
> That is too early. You will get a HIBERNATE
> event anyway. If the write out fails you are
> in trouble if you already reacted to
> PM_EVENT_FREEZE
>
> 	Regards
> 		Oliver
>
>
