From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v2] target/iscsi: Convert timers to use timer_setup()
Date: Mon, 30 Oct 2017 17:04:48 -0700
Message-ID: <CAGXu5j+z9t28n33e6r9hxRNX1hpkzF4Z5sy308sWYh84whkRfQ@mail.gmail.com>
References: <20171027091930.GA14728@beast> <1509109031.3135.1.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1509109031.3135.1.camel@wdc.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "varun@chelsio.com" <varun@chelsio.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "jiangyilism@gmail.com" <jiangyilism@gmail.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 27, 2017 at 5:57 AM, Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
> On Fri, 2017-10-27 at 02:19 -0700, Kees Cook wrote:
>> In preparation for unconditionally passing the struct timer_list pointer to
>> all timer callbacks, switch to using the new timer_setup() and from_timer()
>> to pass the timer pointer explicitly. Includes a fix for correcting an
>> on-stack timer usage.
>
> Hello Kees,
>
> These changes look good to me but I would like to test this patch. Is there
> a tree available somewhere that includes this patch?

I didn't, but in case it's easier to test, I have put it up here,
which is just tip/timers/core with the two target timer patches on
top:

https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=kspp/timer/tip/target

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
