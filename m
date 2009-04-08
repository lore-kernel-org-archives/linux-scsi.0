From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: 2.6.30-rc1: OOPS on usb disk insert
Date: Wed, 8 Apr 2009 06:25:41 -0700
Message-ID: <ac3eb2510904080625m228ddc4dl611c3c5c368fab2a@mail.gmail.com>
References: <49DC3094.5010607@gawab.com> <20090407223828.c9d2cb75.akpm@linux-foundation.org>
	<49DC3F1F.9040306@gawab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:43995 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756188AbZDHNZ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2009 09:25:58 -0400
In-Reply-To: <49DC3F1F.9040306@gawab.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Justin Madru <jdm64@gawab.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>

On Tue, Apr 7, 2009 at 23:07, Justin Madru <jdm64@gawab.com> wrote:
> Andrew Morton wrote:
>> On Tue, 07 Apr 2009 22:05:24 -0700 Justin Madru <jdm64@gawab.com> wr=
ote:

>>> Testing out .30-rc1 and usb devises don't work. I insert my flash d=
isk
>>> and get this oops.

>> The trace appears to be claiming that kernel/async.c:async_new.func =
is
>> NULL.
>>
>> But it cannot be - it's initialised at compilation time. =C2=A0Unles=
s
>> something scribbled on it of course.

I've seen async problems with other subsystem too, maybe caused by a
corruption which is fixed by:
  http://patchwork.kernel.org/patch/16776/

  -static void __init acpi_battery_init_async(void *unused, ...
  +static void acpi_battery_init_async(void *unused, ...

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
