From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCH 3/4] block: replace rssd_disk_name_format() to disk_name_format()
Date: Mon, 02 Apr 2012 09:21:04 +0800
Message-ID: <4F78FF00.5060804@cn.fujitsu.com>
References: <4F7581D4.4040301@cn.fujitsu.com> <4F758297.5020600@cn.fujitsu.com> <4F764778.1030406@micron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4F764778.1030406@micron.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONT - Type 2]" <asamymuthupa@micron.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>, KVM <kvm@vger.kernel.org>, VIRTUAL <virtualization@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

  On 03/31/2012 07:54 AM, Asai Thambi Samymuthu Pattrayasamy 
(asamymuthupa) [CONT - Type 2] wrote:
> On 3/30/2012 2:53 AM, Ren Mingxin wrote:
>
>>   Currently, block core has been supplied "disk_name_format()", so
>> we should remove duplicate function "rssd_disk_name_format()"
>> and use the new function to format rssd disk names.
>>
>> Signed-off-by: Ren Mingxin<renmx@cn.fujitsu.com>
>> ---
>>   mtip32xx.c |   33 +--------------------------------
>>   1 file changed, 1 insertion(+), 32 deletions(-)
>
> Looks fine.
>
> Should the subject be "mtip32xx: ..." instead of "block: ..."? I
> understand "block:" as relating to block core. I am fairly new here. If
> "block:" can be used for block drivers too, that is fine too.
>
>

Good idea! Will be fixed in the next version.

-- 
Thanks,
Ren
