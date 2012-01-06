From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH block:for-3.3/core] cfq: merged request shouldn't jump to
 a different cfqq
Date: Thu, 5 Jan 2012 19:22:24 -0800
Message-ID: <CAOS58YOcciTFzYU9vsW2pnE=dbNo+rGz2XJ0Qjk4VHriNDw31g@mail.gmail.com>
References: <20120103200906.GG31746@google.com>
	<4F03631C.8080501@kernel.dk>
	<20120103221301.GH31746@google.com>
	<20120103223505.GI31746@google.com>
	<20120105012445.GP31746@google.com>
	<alpine.LSU.2.00.1201051026090.2009@eggly.anvils>
	<20120105183842.GF18486@google.com>
	<20120106021707.GA6276@google.com>
	<20120106023638.GC6276@google.com>
	<1325819655.22361.513.camel@sli10-conroe>
	<20120106030406.GD6276@google.com>
	<1325820878.22361.518.camel@sli10-conroe>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <1325820878.22361.518.camel@sli10-conroe>
Sender: linux-next-owner@vger.kernel.org
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, x86@kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 5, 2012 at 7:34 PM, Shaohua Li <shaohua.li@intel.com> wrote=
:
>> That's how cfq has behaved before this recent plug merge breakage an=
d
>> IIRC why the cooperating queue thing is there. =A0If you want to cha=
nge
>> the behavior, that should be an explicit separate patch.
> My point is both cooperating merge and the plug merge of different cf=
q
> are merge, no reason we allow one but disallow the other. plug merge
> isn't a breakage to me.

Isolation is pretty big deal for cfq and cross cfqq merging happening
without cfq noticing it isn't gonna be helpful to the cause.  Why
don't we merge bio's across different cfqq's then?

--=20
tejun
