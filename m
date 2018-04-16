From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [RESEND PATCH v1 1/2] trace: events: scsi: Add tag in SCSI trace
 events
Date: Mon, 16 Apr 2018 10:11:33 -0700
Message-ID: <9a095abe-c016-0c2e-11e2-7253dbad3a6c@wdc.com>
References: <b46de00ee67e4ec9955bb3f09faa36c4@SIWEX5A.sing.micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b46de00ee67e4ec9955bb3f09faa36c4@SIWEX5A.sing.micron.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Bean Huo (beanhuo)" <beanhuo@micron.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "rajatja@google.com" <rajatja@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "mingo@redhad.com" <mingo@redhad.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 04/16/18 10:05, Bean Huo (beanhuo) wrote:
>> On Mon, 2018-04-16 at 09:41 -0700, Rajat Jain wrote:
>>> On Mon, Apr 16, 2018 at 8:28 AM, Steven Rostedt <rostedt@goodmis.org>
>> wrote:
>>>> On Mon, 16 Apr 2018 14:31:49 +0000
>>>> "Bean Huo (beanhuo)" <beanhuo@micron.com> wrote:
>>>>
>>>>> Print the request tag along with other information while tracing a
>>>>> command.
>>>>>
>>>>> Signed-off-by: Bean Huo <beanhuo@micron.com>
>>>
>>> Acked-by: Rajat Jain <rajatja@google.com>
>>
>> This patch is not acceptable because it adds support for tag tracing to the
>> legacy block layer only. Any patch that adds a new feature to the legacy block
>> layer must also add it to blk-mq.
>>
> To be honest, I don't understand your point, can you give me more explanation?

The legacy block layer will be removed as soon as blk-mq provides all 
the functionality of the legacy block layer and as soon as it performs 
at least as well as the legacy block layer for all use cases. If new 
features are added to the legacy block layer but not to blk-mq that 
prevents removal of the legacy block layer. Hence the requirement I 
explained in my previous e-mail.

Bart.
