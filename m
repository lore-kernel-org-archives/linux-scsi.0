From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] libosd: Remove ignored __weak attribute
Date: Fri, 26 Oct 2018 23:15:11 -0700
Message-ID: <ac63f6d2-d9f3-c512-892d-2e4450fd4c1e@acm.org>
References: <20181025213144.GB24709@flashbox>
 <CAKwvOdn=TvoGdFvgxX6TyXBXnhVLttriRrZEnzS6DjcjL64DPA@mail.gmail.com>
 <20181025225548.GA10326@flashbox>
 <CAKwvOdnwmf47_m_0K5OCLmXbrkLNnekpNOPCCMeJqkuqKUbQ-A@mail.gmail.com>
 <1540576908.66186.103.camel@acm.org>
 <CAKwvOdnYx60JkJHJkD7CYA9yx5Oa7Tn9q4aZ3-tcZGx++yoduQ@mail.gmail.com>
 <1540589437.66186.124.camel@acm.org>
 <CAKwvOdm-xYRqCBXhLC1ceC44_rEmggW4qiSgGpRkpL+p-NadVg@mail.gmail.com>
 <1540591147.66186.127.camel@acm.org>
 <CAKwvOdmUhtK10cbYFoEJJp4O8LA_F-+f68A_NcL_fm_FH6QodA@mail.gmail.com>
 <20181027033552.GA29237@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181027033552.GA29237@thunk.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Nick Desaulniers <ndesaulniers@google.com>, Linus Torvalds <torvalds@linux-foundation.org>, ooo@electrozaur.com, Nathan Chancellor <natechancellor@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, hch@infradead.org
List-Id: linux-scsi@vger.kernel.org

On 10/26/18 8:35 PM, Theodore Y. Ts'o wrote:
> The second observation I'll make is that if someone is proposing a
> cleanup patch, it's unfair to dump on the person proposing the cleanup
> patch the (non-trivial) effort to drop a driver/file system/subsystem.

Hi Ted,

Maybe I was not clear enough. It never was my intention to suggest that 
Nick or Nathan should remove the OSD code. This is something I'm willing 
to do myself. BTW, I'm still waiting for someone to explain me why the 
patch at the start of this thread was submitted by people who never have 
used the libosd driver and who do not have any plans to use it ever.

> If the maintainer wants to drop a driver/file system, that should be
> the maintainer's responsibiltiy; not someone proposing a
> cleanup/maintenance patch.

I think anyone who makes tree-wide changes has the freedom to suggest to 
remove a driver. Having to modify drivers that are no longer maintained 
when doing tree-wide changes can be a real pain.

Additionally, you may have missed earlier discussions on the linux-scsi 
mailing list about this driver. The first time it was suggested to 
remove this driver was several years ago. The outcome of a discussion of 
a few weeks ago is that there is agreement about the removal of this 
driver. See also the following messages:
* https://www.spinics.net/lists/linux-scsi/msg123738.html
* https://www.spinics.net/lists/linux-scsi/msg123742.html

Bart.
