From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] block: Revert "[SCSI] genhd: add a new attribute "alias"
 in gendisk"
Date: Wed, 9 Nov 2011 18:19:43 +0100
Message-ID: <CAPXgP109AAzi3z0-87jCs+b21p1eo3fCV7StToksm_GYSax8_A@mail.gmail.com>
References: <20111109162512.GB1260@google.com> <20111109165330.GA13326@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111109165330.GA13326@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, Alan Cox <alan@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 9, 2011 at 17:53, Greg KH <gregkh@suse.de> wrote:
> On Wed, Nov 09, 2011 at 08:25:12AM -0800, Tejun Heo wrote:
>> This reverts commit a72c5e5eb738033938ab30d6a634b74d1d060f10.
>>
>> The commit introduced alias for block devices which is intended to b=
e
>> used during logging although actual usage hasn't been committed yet.
>> This approach adds very limited benefit (raw log might be easier to
>> follow) which can be trivially implemented in userland but has a lot
>> of problems.
>>
>> It is much worse than netif renames because it doesn't rename the
>> actual device but just adds conveninence name which isn't used
>> universally or enforced. =C2=A0Everything internal including device =
lookup
>> and sysfs still uses the internal name and nothing prevents two
>> devices from using conflicting alias - ie. sda can have sdb as its
>> alias.
>>
>> This has been nacked by people working on device driver core, block
>> layer and kernel-userland interface and shouldn't have been
>> upstreamed. =C2=A0Revert it.
>>
>> =C2=A0http://thread.gmane.org/gmane.linux.kernel/1155104
>> =C2=A0http://thread.gmane.org/gmane.linux.scsi/68632
>> =C2=A0http://thread.gmane.org/gmane.linux.scsi/69776
>>
>> Signed-off-by: Tejun Heo <tj@kernel.org>
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
>> Cc: Nao Nishijima <nao.nishijima.xt@hitachi.com>
>> Cc: Kay Sievers <kay.sievers@vrfy.org>
>> Cc: Greg Kroah-Hartman <gregkh@suse.de>
>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

 Acked-by: Kay Sievers <kay.sievers@vrfy.org>

Thanks,
Kay
