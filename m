From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Fri, 26 Oct 2018 14:00:20 -0700
Message-ID: <CAKwvOdnYx60JkJHJkD7CYA9yx5Oa7Tn9q4aZ3-tcZGx++yoduQ@mail.gmail.com>
References: <20180930205448.26205-1-natechancellor@gmail.com>
 <10b12992-3570-4646-374b-82cbd7276839@acm.org> <CAKwvOd=wgxB69dMxzMeH2edCn=TdQGPGkNVW1e=QHPTJtO9ZNw@mail.gmail.com>
 <1538503063.193396.6.camel@acm.org> <CAKwvOdmsNEexQL9R8rgcRcXTZButYM6YWwG8bhVWCoJ8bOqCrA@mail.gmail.com>
 <1538521591.193396.8.camel@acm.org> <20181025213144.GB24709@flashbox>
 <CAKwvOdn=TvoGdFvgxX6TyXBXnhVLttriRrZEnzS6DjcjL64DPA@mail.gmail.com>
 <20181025225548.GA10326@flashbox> <CAKwvOdnwmf47_m_0K5OCLmXbrkLNnekpNOPCCMeJqkuqKUbQ-A@mail.gmail.com>
 <1540576908.66186.103.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540576908.66186.103.camel@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
To: bvanassche@acm.org, ooo@electrozaur.com
Cc: Nathan Chancellor <natechancellor@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 26, 2018 at 11:01 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On Fri, 2018-10-26 at 10:54 -0700, Nick Desaulniers wrote:
> > If creating one instance of this variable is a functional change, I
> > can't help but suspect the original code was wrong.  But maybe Bart,
> > Boaz, or Christoph can clarify or have more thoughts on this?  Looks
> > like Boaz added this header in commit de258bf5e638 ("[SCSI] libosd:
> > OSDv1 Headers").
>
> Hi Nick and Nathan,
>
> Had you noticed the following e-mail from early October:
> https://marc.info/?l=linux-kernel&m=153849955503249?

>From this subthread with Linus, removal of the exofs fs and scsi osd
code would be a user visible change and is not an option. See:
https://lkml.org/lkml/2018/10/27/3
https://lkml.org/lkml/2018/10/27/44

So we should pursue this much smaller fixup.  Boaz, can you clarify
https://lkml.org/lkml/2018/10/26/682
specifically:

> If creating one instance of this variable is a functional change, I
> can't help but suspect the original code was wrong.  But maybe Bart,
> Boaz, or Christoph can clarify or have more thoughts on this?  Looks
> like Boaz added this header in commit de258bf5e638 ("[SCSI] libosd:
> OSDv1 Headers").

-- 
Thanks,
~Nick Desaulniers
