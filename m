From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: This patch triggers a bad gcc bug (was Re: [PATCH] force
 inlining of some byteswap operations)
Date: Mon, 18 Apr 2016 09:12:41 -0500
Message-ID: <20160418141241.gcgfawrtnmfamz6t@treble>
References: <20160413151500.tate3u6trg4agugo@treble>
 <20160416090332.GA30613@gmail.com>
 <20160418133932.cnpxai32qn665un3@treble>
 <4545519.Kr6IHPvbv3@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4545519.Kr6IHPvbv3@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ingo Molnar <mingo@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Thomas Graf <tgraf@suug.ch>, Peter Zijlstra <peterz@infradead.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, jamborm@gcc.gnu.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 18, 2016 at 04:07:51PM +0200, Arnd Bergmann wrote:
> On Monday 18 April 2016 08:39:32 Josh Poimboeuf wrote:
> > 
> > I agree.  So how should we work around the bug in this case?  There have
> > been several suggestions:
> > 
> > - change wwn_to_u64() to __always_inline
> > 
> > - change qla2x00_get_host_fabric_name() to skip the unnecessary call to
> >   wwn_to_u64()
> > 
> > - revert one of the two commits:
> >   bc27fb68aaad ("include/uapi/linux/byteorder, swab: force inlining of some byteswap operations")
> >   ef3fb2422ffe ("scsi: fc: use get/put_unaligned64 for wwn access")
> 
> What about the patch to change get_unaligned_be64() that I posted?
> 
> I think we want to merge that anyway, I just don't know if that helps
> with this particular problem as well.

I replied to your other email about that -- it doesn't seem to help this
issue.

-- 
Josh
