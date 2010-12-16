From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCHSET] block/SCSI: implement in-kernel disk event handling, take#2
Date: Thu, 16 Dec 2010 17:44:59 +0100
Message-ID: <AANLkTinYnb5Aby+d5h64+XmdEj5HT5YDP45GX7BTYArN@mail.gmail.com>
References: <1291838262-21274-1-git-send-email-tj@kernel.org>
 <4D0A3EE1.4050404@kernel.org> <4D0A400F.5090608@kernel.dk> <1292517519.3024.19.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44487 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab0LPQpP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Dec 2010 11:45:15 -0500
In-Reply-To: <1292517519.3024.19.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jack@suse.cz

On Thu, Dec 16, 2010 at 17:38, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2010-12-16 at 17:36 +0100, Jens Axboe wrote:
>> On 2010-12-16 17:31, Tejun Heo wrote:
>> > On 12/08/2010 08:57 PM, Tejun Heo wrote:
>> >> This is the second take of in-kernel-disk-event patchset which
>> >> implements in-kernel disk event handling framework and adds suppo=
rt
>> >> for it to sr and sd. =C2=A0This is largely to move media presence=
 polling
>> >> into kernel as userspace implementation turned out to be quite
>> >> problematic over the years.
>> >
>> > Kay, Jens, James, how does this look to you guys?
>>
>> I like the concept, this is probably what we should have done all al=
ong.
>> The user space method has been tried and failed. So I was mostly lay=
ing
>> it low waiting for feedback before integrating this.
>
> Me too pretty much ... event driven is nice, but it only really works=
 if
> the userspace stuff will stop polling ...

David Zeuthen and I will take care of it, and leave the devices alone
when the kernel tells us it's not needed to poll from userspace.

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
