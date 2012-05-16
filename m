From: chetan loke <loke.chetan@gmail.com>
Subject: Re: SCSI RAM driver ported to 3.3 kernel for file system and I/O testing
Date: Wed, 16 May 2012 15:37:56 -0400
Message-ID: <CAAsGZS5wivyHUGNtHuTNCQQnnqZ=qt-7uSZjbE-7_KC+L-Yoaw@mail.gmail.com>
References: <1337188023.3796.130.camel@schen9-DESK>
	<CAAsGZS6KJ6jN+0B2Q06gXivaWfMVKX9t-yCYNwZDZ_jzUopviw@mail.gmail.com>
	<20120516193506.GM22985@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120516193506.GM22985@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 16, 2012 at 3:35 PM, Matthew Wilcox <willy@linux.intel.com>=
 wrote:
> On Wed, May 16, 2012 at 03:31:55PM -0400, chetan loke wrote:
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (list_empty(=
&ram_device->commands))
>> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 wake_up_process(ram_device->thread);
>>
>> Didn't look in detail but if the queue is empty then why would you
>> want to wake up the kthread? What if you just wake_up after
>> list_add_tail below?
>
> If the list is non-empty, then the kthread has already been woken up
> and doesn't need to be woken again.

Sorry, not able to follow. wait_even_interruptible will put kthread to
sleep. So how will it be already awake?
