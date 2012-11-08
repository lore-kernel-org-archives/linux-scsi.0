From: Andy Grover <agrover@redhat.com>
Subject: Re: scsi target, likely GPL violation
Date: Thu, 08 Nov 2012 08:57:04 -0800
Message-ID: <509BE460.6010404@redhat.com>
References: <509A915B.30105@redhat.com> <CAPoiz9wzx_NmuA1ty-U28MGiYr7XKCbDn_e0ZLmz=pNDCqwqFw@mail.gmail.com> <509B117A.6070708@genband.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <509B117A.6070708@genband.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Friesen <chris.friesen@genband.com>
Cc: Jon Mason <jdmason@kudzu.us>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Marc Fleischmann <mwf@risingtidesystems.com>, Nicholas Bellinger <nab@risingtidesystems.com>
List-Id: linux-scsi@vger.kernel.org

On 11/07/2012 05:57 PM, Chris Friesen wrote:
> On 11/07/2012 07:02 PM, Jon Mason wrote:
>> I'm not a lawyer, nor do I play one on TV, but if
>> I understand the GPL correctly, RTS only needs to provide the relevant
>> source to their customers upon request.
> 
> Not quite.
> 
> Assuming the GPL applies, and that they have modified the code, then
> they must either:
> 
> 1) include the source with the distributed binary
> 
> or
> 
> 2) include with the binary an offer to provide the source to *any* third
> party

So you'd have me find one of their customers, and then get the source
via your #2 method...

...and then turn around and submit it to Nick since he's the target
subsystem maintainer? Nick is probably the one who wrote it!

I'm happy to do that, but we should recognize something is seriously
skewed when the person nominally in charge of the in-kernel code also
has a vested interest in *not* seeing new features added, since it then
competes better with his company's offering.

RTS is trying to use an "open core" business model. This works fine for
BSD-licensed code or code originally authored entirely by you, but their
code (all of it even the new stuff) is a derivative work of the Linux
kernel source code, and the GPL says they need to contribute it back.

Regards -- Andy
