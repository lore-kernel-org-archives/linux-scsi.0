From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass
 of disks naming
Date: Sat, 31 Mar 2012 09:14:26 +0800
Message-ID: <4F765A72.6090006@cn.fujitsu.com>
References: <4F7581D4.4040301@cn.fujitsu.com> <4F7582B0.5010609@cn.fujitsu.com> <CAFO3S427vWXHBDaRmfwqZrGZ2Y8RPUn7CQswQou9EGMh43jU8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:17015 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab2CaBOI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Mar 2012 21:14:08 -0400
In-Reply-To: <CAFO3S427vWXHBDaRmfwqZrGZ2Y8RPUn7CQswQou9EGMh43jU8Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Asias He <asias.hejun@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>, KVM <kvm@vger.kernel.org>, VIRTUAL <virtualization@lists.linux-foundation.org>

  Hi, He:

On 03/30/2012 07:22 PM, Asias He wrote:
> On Fri, Mar 30, 2012 at 5:53 PM, Ren Mingxin<renmx@cn.fujitsu.com>  wrote:
>>   The current virtblk's naming algorithm only supports 263  disks.
>> If there are mass of virtblks(exceeding 263), there will be disks
>> with the same name.
> This fix is pretty nice. However, current virtblk's naming still
> supports up to 18278 disks, no?
> ( index 0  ->  vda, index 18277 ->  vdzzz ).

Sorry, I intended to type 26^3+ (26^2+26)...
It may still be a restriction which should be improved though.

Thanks,
Ren
