From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Fri, 26 Oct 2018 12:22:06 -0700
Message-ID: <CAHk-=wh0LsuM+kAZGbDaogDdSbdCk3GvXmjYVAMkpmLj2=VF=g@mail.gmail.com>
References: <10b12992-3570-4646-374b-82cbd7276839@acm.org> <CAKwvOd=wgxB69dMxzMeH2edCn=TdQGPGkNVW1e=QHPTJtO9ZNw@mail.gmail.com>
 <1538503063.193396.6.camel@acm.org> <CAKwvOdmsNEexQL9R8rgcRcXTZButYM6YWwG8bhVWCoJ8bOqCrA@mail.gmail.com>
 <1538521591.193396.8.camel@acm.org> <20181025213144.GB24709@flashbox>
 <CAKwvOdn=TvoGdFvgxX6TyXBXnhVLttriRrZEnzS6DjcjL64DPA@mail.gmail.com>
 <20181025225548.GA10326@flashbox> <CAKwvOdnwmf47_m_0K5OCLmXbrkLNnekpNOPCCMeJqkuqKUbQ-A@mail.gmail.com>
 <1540576908.66186.103.camel@acm.org> <20181026180515.GA12129@flashbox> <CAKwvOdnEHCmNjm-P068KQrbU0K+Dzyw_+_j7XLKJET0LWSz86A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKwvOdnEHCmNjm-P068KQrbU0K+Dzyw_+_j7XLKJET0LWSz86A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: bvanassche@acm.org, ooo@electrozaur.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, natechancellor@gmail.com, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 26, 2018 at 11:32 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> + Linus
> I'm not about the process of removing code from the kernel.  Doesn't
> that violate the "thou shalt not break userspace" rule?

The only thing that breaks the "thou shalt not break userspace" rule
is fairly simple: things that break user space.

Does removing the code break for somebody? If so we don't do it. But
if nobody notices because nobody uses, it's fine.

Basically, there is no "theoretical" rule about what breaks user space
or not. In particular, the rule is *not* that you can't change ABI.
You can do any change you want that changes a kernel exported ABI,
just as long as nobody actually notices the change.

But in practice, it's often _much_ more work to try to figure out
whether something breaks somebody than it is to just say "don't change
behavior", so 99% of the time, the rule ends up being just "try to
avoid intentionally changing behavior, because you'll likely get it
wrong".

              Linus
