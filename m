From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Fri, 26 Oct 2018 11:31:51 -0700
Message-ID: <CAKwvOdnEHCmNjm-P068KQrbU0K+Dzyw_+_j7XLKJET0LWSz86A@mail.gmail.com>
References: <10b12992-3570-4646-374b-82cbd7276839@acm.org> <CAKwvOd=wgxB69dMxzMeH2edCn=TdQGPGkNVW1e=QHPTJtO9ZNw@mail.gmail.com>
 <1538503063.193396.6.camel@acm.org> <CAKwvOdmsNEexQL9R8rgcRcXTZButYM6YWwG8bhVWCoJ8bOqCrA@mail.gmail.com>
 <1538521591.193396.8.camel@acm.org> <20181025213144.GB24709@flashbox>
 <CAKwvOdn=TvoGdFvgxX6TyXBXnhVLttriRrZEnzS6DjcjL64DPA@mail.gmail.com>
 <20181025225548.GA10326@flashbox> <CAKwvOdnwmf47_m_0K5OCLmXbrkLNnekpNOPCCMeJqkuqKUbQ-A@mail.gmail.com>
 <1540576908.66186.103.camel@acm.org> <20181026180515.GA12129@flashbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181026180515.GA12129@flashbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bvanassche@acm.org, ooo@electrozaur.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Nathan Chancellor <natechancellor@gmail.com>, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 26, 2018 at 11:05 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Fri, Oct 26, 2018 at 11:01:48AM -0700, Bart Van Assche wrote:
> > On Fri, 2018-10-26 at 10:54 -0700, Nick Desaulniers wrote:
> > > If creating one instance of this variable is a functional change, I
> > > can't help but suspect the original code was wrong.  But maybe Bart,
> > > Boaz, or Christoph can clarify or have more thoughts on this?  Looks
> > > like Boaz added this header in commit de258bf5e638 ("[SCSI] libosd:
> > > OSDv1 Headers").
> >
> > Hi Nick and Nathan,
> >
> > Had you noticed the following e-mail from early October:
> > https://marc.info/?l=linux-kernel&m=153849955503249?
> >
> > Thanks,
> >
> > Bart.
>
> Hi Bart,
>
> I had but there doesn't seem to be any reply to it so I wasn't sure if
> there was a final consensus on removing the driver. If that's the route
> that everyone wants to go, then I guess we don't need to continue to
> debate this patch.
>
> Thanks for the heads up,
> Nathan

I've staged a RFC patch here:
https://github.com/ClangBuiltLinux/linux/commit/03817d982606e2db143d23a8a55e97de6de6e0c2

+ Linus
I'm not about the process of removing code from the kernel.  Doesn't
that violate the "thou shalt not break userspace" rule?  But code does
get deleted from the kernel... ex:
http://lkml.iu.edu/hypermail/linux/kernel/1804.1/06654.html

-- 
Thanks,
~Nick Desaulniers
