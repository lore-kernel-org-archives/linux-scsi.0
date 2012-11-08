From: Dave Airlie <airlied@gmail.com>
Subject: Re: scsi target, likely GPL violation
Date: Fri, 9 Nov 2012 06:22:42 +1000
Message-ID: <CAPM=9tw+SMCXXoDjkTETPxOk+Oj8jOfR-9tbx8KYpsWh5_WeAg@mail.gmail.com>
References: <509A915B.30105@redhat.com>
	<CAPoiz9wzx_NmuA1ty-U28MGiYr7XKCbDn_e0ZLmz=pNDCqwqFw@mail.gmail.com>
	<509B117A.6070708@genband.com>
	<509BE460.6010404@redhat.com>
	<1352405111.29589.476.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1352405111.29589.476.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@risingtidesystems.com
Cc: Andy Grover <agrover@redhat.com>, Chris Friesen <chris.friesen@genband.com>, Jon Mason <jdmason@kudzu.us>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Marc Fleischmann <mwf@risingtidesystems.com>
List-Id: linux-scsi@vger.kernel.org

>> ...and then turn around and submit it to Nick since he's the target
>> subsystem maintainer? Nick is probably the one who wrote it!
>>
>> I'm happy to do that, but we should recognize something is seriously
>> skewed when the person nominally in charge of the in-kernel code also
>> has a vested interest in *not* seeing new features added, since it then
>> competes better with his company's offering.
>>
>> RTS is trying to use an "open core" business model. This works fine for
>> BSD-licensed code or code originally authored entirely by you, but their
>> code (all of it even the new stuff) is a derivative work of the Linux
>> kernel source code, and the GPL says they need to contribute it back.
>>
>
> Andy,
>
> Accusing us of violating GPL is a serious legal claim.
>
> In fact, we are not violating GPL.  In short, this is because we wrote
> the code you are referring to (the SCSI target core in our commercial
> RTS OS product), we have exclusive copyright ownership of it, and this
> code contains no GPL code from the community.  GPL obligations only
> apply downstream to licensees, and not to the author of the code.  Those
> who use the code under GPL are subject to its conditions; we are not.

Just to clarify since I'm not a major GPL expert. Are you:

a) distributing a Linux kernel

b) with a module built against it to be linked into it, whether
completely written in house or not?

Then the module is under the GPL, if you think you are like nvidia or
someone then think again, the corner case they live under is that they
don't distribute a Linux kernel with their module *ever*, and they
have a clear call for non-derived work status since its 90% the same
code as in their Windows drivers.

But if you distribute a kernel and a module in one place which I
assume RTS OS does, then you are in dangerous territory and could be
hit with cease and desist notices, which has happened to people
shipping kernels and linked nvidia binary drivers before.

Dave.
