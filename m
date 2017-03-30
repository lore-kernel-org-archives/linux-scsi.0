From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Subject: Re: [PATCHv5 0/2] tcmu: For bugs fix only
Date: Thu, 30 Mar 2017 17:11:26 +0800
Message-ID: <7336c3b5-7a9a-d804-e308-a18383b7eb0a@cmss.chinamobile.com>
References: <1490605661-16127-1-git-send-email-lixiubo@cmss.chinamobile.com>
 <1490863702.6977.7.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1490863702.6977.7.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: agrover@redhat.com, mchristi@redhat.com, shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, bryantly@linux.vnet.ibm.com, iliastsi@arrikto.com
List-Id: linux-scsi@vger.kernel.org

On 2017年03月30日 16:48, Nicholas A. Bellinger wrote:
> Hi Xiubo & Co,
>
> On Mon, 2017-03-27 at 17:07 +0800, lixiubo@cmss.chinamobile.com wrote:
>> From: Xiubo Li <lixiubo@cmss.chinamobile.com>
>>
>> Changed for V5:
>> - This only includes #1 and #2. And for old #3, #4 are still reviewing.
>> - #1, since the issue reported by Ilias is a separate new one, and will
>>    create a new patch later.
>> - #2, address the issue pointed out by Mike, thanks.
>> - #1 and #2 have been tested by Ilias in BIDI case, thanks.
>>
>> Changed for V4:
>> - re-order the #3, #4 at the head.
>> - merge most of the #5 to others.
>>
>> Xiubo Li (2):
>>    tcmu: Fix possible overwrite of t_data_sg's last iov[]
>>    tcmu: Fix wrongly calculating of the base_command_size
>>
>>   drivers/target/target_core_user.c | 44 +++++++++++++++++++++++++++------------
>>   1 file changed, 31 insertions(+), 13 deletions(-)
>>
> Applied to target-pending/master, along with CC's for 3.19.y stable.
>
> Thanks Xiubo !
>
> Btw, I fixed-up the ordering of the Reviewed-by + Tested-by +
> Signed-off-by tags on the patches here:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git/commit/?id=ab22d2604c86ceb01bb2725c9860b88a7dd383bb
> https://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git/commit/?id=abe342a5b4b5aa579f6bf40ba73447c699e6b579
>
> Just for future reference, the flow of these tags should reflect the
> history of the patch.  Eg:
>
> Reviewed-by: First reviewer <foo@bar.com>
> Tested-by: First tester <foo2@bar2.com>
> Reviewed-by: Second reviewer <foo3@bar3.com>
> Signed-off-by: Patch Author <you@yourdomain.com>
>
> and then once the subsystem maintainer merges it into his tree, they add
> their own:
>
> Signed-off-by: Subsystem Maintainer <superturboarray@linux-domain.org>

Sure, thanks very much.

> Beyond that, what is the status of the other two feature improvement
> patches..?
>
> Do you intend to post those (again) as v4.12-rc1 material..?
>
Since the #2 has changed in V5, and the old #3 will have a conflict with 
it.

The #3 and #4 are still in reviewing process, so I will post it again if 
they are all okay later.

Thanks,

BRs
Xiubo
