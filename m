From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Fri, 26 Oct 2018 15:24:44 -0700
Message-ID: <1540592684.66186.136.camel@acm.org>
References: <20180930205448.26205-1-natechancellor@gmail.com>
         <10b12992-3570-4646-374b-82cbd7276839@acm.org>
         <CAKwvOd=wgxB69dMxzMeH2edCn=TdQGPGkNVW1e=QHPTJtO9ZNw@mail.gmail.com>
         <1538503063.193396.6.camel@acm.org>
         <CAKwvOdmsNEexQL9R8rgcRcXTZButYM6YWwG8bhVWCoJ8bOqCrA@mail.gmail.com>
         <1538521591.193396.8.camel@acm.org> <20181025213144.GB24709@flashbox>
         <CAKwvOdn=TvoGdFvgxX6TyXBXnhVLttriRrZEnzS6DjcjL64DPA@mail.gmail.com>
         <20181025225548.GA10326@flashbox>
         <CAKwvOdnwmf47_m_0K5OCLmXbrkLNnekpNOPCCMeJqkuqKUbQ-A@mail.gmail.com>
         <1540576908.66186.103.camel@acm.org>
         <CAKwvOdnYx60JkJHJkD7CYA9yx5Oa7Tn9q4aZ3-tcZGx++yoduQ@mail.gmail.com>
         <1540589437.66186.124.camel@acm.org>
         <CAKwvOdm-xYRqCBXhLC1ceC44_rEmggW4qiSgGpRkpL+p-NadVg@mail.gmail.com>
         <1540591147.66186.127.camel@acm.org>
         <CAKwvOdmUhtK10cbYFoEJJp4O8LA_F-+f68A_NcL_fm_FH6QodA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKwvOdmUhtK10cbYFoEJJp4O8LA_F-+f68A_NcL_fm_FH6QodA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Desaulniers <ndesaulniers@google.com>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: ooo@electrozaur.com, Nathan Chancellor <natechancellor@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-10-26 at 15:07 -0700, Nick Desaulniers wrote:
+AD4 I don't disagree with you, I just don't see how what you state can be
+AD4 reconciled with Linus' response in
+AD4 https://lkml.org/lkml/2018/10/27/44.  Those two viewpoints seem
+AD4 incompatible to me, but maybe there's a nuance I'm missing?

I don't think there is any disagreement nor that there are any conflicting
viewpoints. As explained in previous e-mails it is unlikely that anyone is
using these kernel drivers and as far as I know Linus is OK with removing
unused kernel drivers.

+AD4 Nathan and I are just pointing out a small fix to eliminate a small
+AD4 warning, deleting all this code does kind of feels like +ACI-throwing out
+AD4 the baby with the bath water.+ACI A nuclear option for what would be a
+AD4 small change otherwise.  Maybe it's good to discuss the EOL for
+AD4 exofs/osd, but can we please decouple that conversation from the small
+AD4 change Nathan and I are proposing?

Removing a kernel driver is not a nuclear option. You may not be aware of
this but it happens all the time. From a maintainer point of view it is a
very sensible action because there are people who keep submitting cleanup
patches for kernel drivers they do not use themselves. Every individual
patch needs some attention and hence causes some work for a kernel
maintainer. Removing kernel drivers that are not used helps to reduce the
workload of a maintainer and hence is a rational action. Additionally, if
anyone would ever complain about removal of a kernel driver, it can be
brought back by reverting the commit through which it has been removed.
Martin, please reply if you see this differently.

Bart.
