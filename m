From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH 2/2] target: use new "dbroot" target attribute
Date: Fri, 1 Apr 2016 11:18:02 -0700
Message-ID: <56FEBB5A.2000205@redhat.com>
References: <cover.1459278305.git.lduncan@suse.com>
 <e2b3b2a176b28155e43365e30c58e5a00cfab673.1459278305.git.lduncan@suse.com>
 <394f77609c81d2274cee31a51318d89e@suse.de> <56FEB771.7090901@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <56FEB771.7090901@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: Lee Duncan <lduncan@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org, hch@infradead.org, lkml@vger.kernel.org, hare@suse.com, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/01/2016 11:01 AM, Lee Duncan wrote:
> On 04/01/2016 12:58 AM, Johannes Thumshirn wrote:
>> On 2016-03-31 20:05, Lee Duncan wrote:
>>> This commit updates the target core ALUA and PR
>>> modules to use the new "dbroot" attribute instead
>>> of assuming the target database is in "/var/target".
>>
>> Same goes for this one,
>>
>> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>> as soon as it has a Signed-off-by line
>
> Thanks Johannes.
>
> I will wait to see if there are any other comments, then resubmit v2.

Seems fine to me, too.

So, if not /var/target, where do you recommend we be pointing this to?
