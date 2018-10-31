From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: remove exofs and the T10 OSD code V2
Date: Thu, 1 Nov 2018 09:07:51 +1100 (AEDT)
Message-ID: <alpine.LNX.2.21.1811010846490.8@nippy.intranet>
References: <20181027082019.20838-1-hch@lst.de> <c9740eeb-6b96-35b6-a436-7537669da1a9@electrozaur.com> <1541006979.196084.138.camel@acm.org> <6794b3a0-fe57-cd8b-3ad3-3a590121b12a@electrozaur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6794b3a0-fe57-cd8b-3ad3-3a590121b12a@electrozaur.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <ooo@electrozaur.com>
Cc: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com, Nick Desaulniers <ndesaulniers@google.com>, Nathan Chancellor <natechancellor@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 31 Oct 2018, Boaz Harrosh wrote:

> > [...] All changes made by other kernel developers than you are the 
> > result of tree-wide refactoring, compiler warning fixes, fixes for 
> > issues detected by static source code analyzers or spelling fixes. 
> > Hence my question: how big is the user base of the exofs and osd 
> > kernel drivers?
> > 
> 
> Not big at all. And none of them production setups. As I said mainly 
> used by academia.
> 

For its part, academia has provided tools to automate the mindless and 
error-prone refactoring which Bart points to. I'm mainly thinking of LLVM 
and Ocaml. (I'm not a computer scientist.)

But I fear that code transformation tools lie beyond the skill and ability 
of those of us who submit spelling fixes.

So the tools need to be made more usable in this setting. Corporate users 
of kernel code who happen to have their own IDE products (Microsoft, 
Google, etc.) have an opportunity here.

-- 

> Thanks
> Boaz
> 
> > Thanks,
> > Bart.
> 
> 
