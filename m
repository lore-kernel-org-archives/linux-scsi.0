From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [Open-FCoE] [PATCH] fix mm leakage of block request in SCSI
 FiberChannel transport
Date: Sat, 17 Sep 2011 10:31:18 +0800
Message-ID: <CAJd=RBAaLby7uvqqPEnAW6rRTqC6LmB2YTZJRRgd=JR3E1bHbw@mail.gmail.com>
References: <CAPkVYS7YOHCCOY5nDVsiAxcJBfAaD=yGpeNO9+K6V9bx1Weu_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43627 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1IQCbU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Sep 2011 22:31:20 -0400
Received: by wwf22 with SMTP id 22so5784410wwf.1
        for <linux-scsi@vger.kernel.org>; Fri, 16 Sep 2011 19:31:18 -0700 (PDT)
In-Reply-To: <CAPkVYS7YOHCCOY5nDVsiAxcJBfAaD=yGpeNO9+K6V9bx1Weu_g@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Rose <mbryanr@gmail.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, Robert Love <robert.w.love@intel.com>

On Mon, Sep 12, 2011 at 8:57 PM, Mike Rose <mbryanr@gmail.com> wrote:
> https://lists.open-fcoe.org/pipermail/devel/2010-November/010794.html
> Hello Hillf,
> I happened to read about one of your patches, and was wondering if th=
at is
> one of the fixes for the
>
>
> BLK_EH_NOT_HANDLED error, in particular the sluggish system response =
with
> the=C2=A0AOC-SASLP-MV8 installed.
> This occurs with an unRAID array, Linux 3.0.3, syslog attached.
> Thank you,
> Mike

Hi Mike,

I am not sure the patch, delivered about one year ago and not applied, =
could be
used to solve the questions you encountered, but forward it to the rele=
vant
mailing lists.

btw, please give a short description of your questions then.

Hillf
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
