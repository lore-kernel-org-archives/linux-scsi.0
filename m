From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Fri, 26 Oct 2018 14:02:06 -0700
Message-ID: <CAKwvOdknFO8h0q2zekThPiwije6_LYMjAktrX___Oc76o=Qhdg@mail.gmail.com>
References: <10b12992-3570-4646-374b-82cbd7276839@acm.org> <CAKwvOd=wgxB69dMxzMeH2edCn=TdQGPGkNVW1e=QHPTJtO9ZNw@mail.gmail.com>
 <1538503063.193396.6.camel@acm.org> <CAKwvOdmsNEexQL9R8rgcRcXTZButYM6YWwG8bhVWCoJ8bOqCrA@mail.gmail.com>
 <1538521591.193396.8.camel@acm.org> <20181025213144.GB24709@flashbox>
 <CAKwvOdn=TvoGdFvgxX6TyXBXnhVLttriRrZEnzS6DjcjL64DPA@mail.gmail.com>
 <20181025225548.GA10326@flashbox> <CAKwvOdnwmf47_m_0K5OCLmXbrkLNnekpNOPCCMeJqkuqKUbQ-A@mail.gmail.com>
 <1540576908.66186.103.camel@acm.org> <20181026180515.GA12129@flashbox>
 <CAKwvOdnEHCmNjm-P068KQrbU0K+Dzyw_+_j7XLKJET0LWSz86A@mail.gmail.com>
 <CAHk-=wh0LsuM+kAZGbDaogDdSbdCk3GvXmjYVAMkpmLj2=VF=g@mail.gmail.com>
 <CAKwvOd=c9RG2s3f-PgM1T84sHc5N9zcjrVpG5is+mGbTOxvtrQ@mail.gmail.com> <CAHk-=whazvE2VnJiSFeQ_BzU2iUUt=v8BxhgJyq92ecDayJ14g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHk-=whazvE2VnJiSFeQ_BzU2iUUt=v8BxhgJyq92ecDayJ14g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bvanassche@acm.org, ooo@electrozaur.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Nathan Chancellor <natechancellor@gmail.com>, hch@infradead.org, Kees Cook <keescook@google.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 26, 2018 at 1:42 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, Oct 26, 2018 at 1:06 PM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> >
> > Is removing a filesystem considered a userspace breakage?
>
> Yes - if a user notices.
>
> The key word is *USER*.
>
> Note that it's not "user space". It's not about _programs_ noticing,
> it's literally about users and their workflows.
>
> If some change breaks a real user workflow, it needs to be reverted.
>
> So this is not about ABI or anything like that. We've had cases where
> the ABI stayed the same, but the order of device probing changed, and
> that broke peoples setups (because now /dev/sdb and /dev/sda switched
> places), and we had to revert.
>
> It's literally about "if a user upgrades a kernel, and something no
> longer works, it's a regression".
>
> In general, a good idea is "if you have to wonder about it, just don't
> do it".  Because it turns out that users are odd, and often do odd
> things much after you'd have thought they'd have long since switched
> to more modern hardware or filesystems.
>
>                       Linus

Makes sense and is a consistent stance.  Thanks for clarifying.  Will
pursue the smaller fix in the other subthread.
https://lkml.org/lkml/2018/10/27/55

-- 
Thanks,
~Nick Desaulniers
