From: "Zephaniah E. Loss-Cutler-Hull" <warp@aehallh.com>
Subject: Re: General protection fault with use_blk_mq=1.
Date: Thu, 29 Mar 2018 22:43:16 -0700
Message-ID: <c74c49e4-8b34-4361-a4ad-b4e9de2110a6@aehallh.com>
References: <7d8a9c62-7d3e-879c-5b5b-30707f04553e@aehallh.com>
 <ae71cc99-02f1-2b42-bb76-d6e28d61ca21@kernel.dk>
 <b347896e-f770-8987-ad90-a595a5fa926a@aehallh.com>
 <735c5d75-eacf-8ed2-ba9b-9ff4b0b5290d@kernel.dk>
 <882A26D2-BEB8-4CE3-B132-0DE31BFD5D28@linaro.org>
 <0a96375b-5a2e-e828-fa1f-a14af192be4c@aehallh.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0a96375b-5a2e-e828-fa1f-a14af192be4c@aehallh.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Valente <paolo.valente@linaro.org>, Jens Axboe <axboe@kernel.dk>
Cc: "Zephaniah E. Loss-Cutler-Hull" <warp-spam_kernel@aehallh.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 03/29/2018 02:12 AM, Zephaniah E. Loss-Cutler-Hull wrote:
> On 03/28/2018 10:13 PM, Paolo Valente wrote:
>> In addition, the outcome of your attempt without
>> CONFIG_DEBUG_BLK_CGROUP would give us useful bisection information:
>> - if no failure occurs, then the issue is likely to be confined in
>> that debugging code (which, on the bright side, is likely to be of
>> occasional interest, for only a handful of developers)
>> - if the issue still shows up, then we may have new hints on this odd
>> failure
>>
>> Finally, consider that this issue has been reported to disappear from
>> 4.16 [1], and, as a plus, that the service quality of BFQ had a
>> further boost exactly from 4.16.
> 
> I look forward to that either way then.
>>
>> Looking forward to your feedback, in case you try BFQ without
>> CONFIG_DEBUG_BLK_CGROUP,
> 
> I'm running that now, judging from the past if it survives until
> tomorrow evening then we're good, so I should hopefully know in the next
> day.

Alright, I now have an uptime of over 20 hours, with
scsi_mod.use_blk_mq=1 dm_mod.use_blk_mq=1

I did upgrade from 4.15.13 to 4.15.14 in the process, but a quick look
at the changes doesn't have anything jump out at me as impacting this.

So I'm reasonably comfortable stating that disabling
CONFIG_DEBUG_BLK_CGROUP was sufficient to render this stable.

Regards,
Zephaniah E. Loss-Cutler-Hull.
