From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] iscsi-target: Convert timers to use timer_setup()
Date: Thu, 26 Oct 2017 10:24:53 +0200
Message-ID: <CAGXu5j+xk+tHh5z9Hvtg6kGSuZQcK=QYHpcZf_akMnKjP69CKA@mail.gmail.com>
References: <20171025100145.GA144703@beast> <CAHmME9pJRRhWg3=eorVkkSXhpsPgeCfRJFJp2i1-kdXr_E0PCA@mail.gmail.com>
 <CAGXu5jKNDM8NjgtgBp-XapHEiaY_ryk3pBXdaryux6spX++zmQ@mail.gmail.com> <1508943795.4165.18.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:49979 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932199AbdJZIYz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2017 04:24:55 -0400
Received: by mail-io0-f193.google.com with SMTP id n137so3845847iod.6
        for <linux-scsi@vger.kernel.org>; Thu, 26 Oct 2017 01:24:54 -0700 (PDT)
In-Reply-To: <1508943795.4165.18.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "Jason@zx2c4.com" <Jason@zx2c4.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jiangyilism@gmail.com" <jiangyilism@gmail.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "varun@chelsio.com" <varun@chelsio.com>

On Wed, Oct 25, 2017 at 5:03 PM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Wed, 2017-10-25 at 16:10 +0200, Kees Cook wrote:
>> However, maintainers: sorry to send this one -- it can't be merged
>> yet, this uses timer_setup_on_stack() which is only in -next right
>> now. If it looks okay, though, I can carry this in the timer tree.
>
> Hello Kees,
>
> Can you have a look at the following patch and queue it before your
> patch if you think this would be useful (this patch has been tested):
> "target/iscsi: Simplify timer manipulation code"
> (https://www.spinics.net/lists/target-devel/msg15385.html).

This looks good, yeah. Can you resend it with me CCed? It doesn't look
like it was CCed to lkml, so it's not easy to for me to add it to me
tree.

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
