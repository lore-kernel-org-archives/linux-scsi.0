From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] block: Revert "[SCSI] genhd: add a new attribute "alias"
 in gendisk"
Date: Fri, 11 Nov 2011 14:09:29 -0500
Message-ID: <4EBD72E9.4020805@interlog.com>
References: <20111109162512.GB1260@google.com> <4EBD361E.5040106@hitachi.com> <20111111173633.GA24351@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111111173633.GA24351@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: Nao Nishijima <nao.nishijima.xt@hitachi.com>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@linux.intel.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11-11-11 12:36 PM, Greg KH wrote:
> On Fri, Nov 11, 2011 at 11:50:06PM +0900, Nao Nishijima wrote:
>> Hi,
>>
>> Finally, I understood why this patch is not acceptable and would lik=
e to
>> solve the problem of the device name mismatch in *user space* using
>> udev. So, could you please give me your comment about it?
>>
>> I aim to unify the device name because the name shown in command out=
put
>> is different from it that users use for command execution.
>>
>> So, I'd like to suggest that two new API should be added to udev.
>> - The API that returns any symlinks such as by-uuid, by id that user=
s
>>    selected before if a device name is given as arguments
>>    If the commands directly access to proc filesystems, they cannot =
get
>>    the symlinks. These commands should get the device name via this =
API.
>> - The API that replaces device name to symlink in text messages
>> =E3=80=80=E3=80=80The dmesg and syslog messages include the raw devi=
ce names such as
>>    sdX. They should be replaced with symlinks to unify the device na=
mes.
>> - udev support alias
>>    Symlinks (by-uuid, by-id =E2=80=A6) is too long, compared to befo=
re (e.g.
>>    sdX). I guess most of users need more friendly and short names.
>>
>> Could you give me some advice or comments?
>> (I will post this idea udev mailing list with prototype code)
>
> Patches are always best to work off of, please post your changes to u=
dev
> to the linux-hotplug list and we can take it from there.

=2E.. and getting examples of acceptable code and APIs
for that purpose might help the requester (and others)
produce those patches.

Doug Gilbert
