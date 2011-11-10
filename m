From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: segfault the use xen and multipath devices
Date: Thu, 10 Nov 2011 20:07:12 +0100
Message-ID: <CAO+b5-r2j2DykAQ3vK06FO7=4nEhRsrC-gwGpUv-=8_zFhXKXg@mail.gmail.com>
References: <CACaajQtfbG=qs5c3RKQUUQ4d5UhQ=mB6o78rQw7hBMpQ0WD8tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41600 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab1KJTHQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2011 14:07:16 -0500
Received: by wyh15 with SMTP id 15so3078642wyh.19
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2011 11:07:14 -0800 (PST)
In-Reply-To: <CACaajQtfbG=qs5c3RKQUUQ4d5UhQ=mB6o78rQw7hBMpQ0WD8tg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
Cc: linux-scsi@vger.kernel.org

On Thu, Nov 10, 2011 at 10:52 AM, Vasiliy Tolstov <v.tolstov@selfip.ru> wrote:
> and in dmesg i see segfault: BUG: unable to handle kernel NULL pointer
> dereference at 0000000000000038
>
> afte that scsi doing offline second target: scsi 5:0:0:1: Device
> offlined - not ready after error recovery
>
> after that i see: invalid opcode: 0000 [#2] SMP
>
> Does this messages says, that in kernel scsi subsystem not works fine
> or they says about xen related problems?

Does this patch help: http://marc.info/?l=linux-scsi&m=131680195721932 ?

Bart.
