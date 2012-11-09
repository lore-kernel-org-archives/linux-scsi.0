From: Andy Grover <agrover@redhat.com>
Subject: Re: scsi target, likely GPL violation
Date: Fri, 09 Nov 2012 15:16:03 -0800
Message-ID: <509D8EB3.5030408@redhat.com>
References: <509A915B.30105@redhat.com>  <CAPoiz9wzx_NmuA1ty-U28MGiYr7XKCbDn_e0ZLmz=pNDCqwqFw@mail.gmail.com>  <509B117A.6070708@genband.com>  <509BE460.6010404@redhat.com>  <1352405111.29589.476.camel@haakon2.linux-iscsi.org>  <509C22B2.8010600@redhat.com> <1352426896.29589.512.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1352426896.29589.512.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@risingtidesystems.com
Cc: Chris Friesen <chris.friesen@genband.com>, Jon Mason <jdmason@kudzu.us>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Marc Fleischmann <mwf@risingtidesystems.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On 11/08/2012 06:08 PM, Nicholas A. Bellinger wrote:
> Support for certified VAAI is part of our commercial target core. The
> target core constitutes a stand-alone kernel subsystem of which we are
> the sole copyright owners. In addition, our target contains a number of
> backend drivers, of which we are also the sole copyright owners, and a
> number of fabric modules, of which some we are the sole copyright
> owners, and of which others we are not, as you pointed out. A
> substantial fraction of the code of which we own the sole copyright was
> certified by BlackDuck Software as early as in 2007. 

See this:

http://www.gnu.org/licenses/gpl-2.0.html from section 2

"These requirements apply to the modified work as a whole. If
identifiable sections of that work are not derived from the Program, and
can be reasonably considered independent and separate works in
themselves, then this License, and its terms, do not apply to those
sections when you distribute them as separate works. But when you
distribute the same sections as part of a whole which is a work based on
the Program, the distribution of the whole must be on the terms of this
License, whose permissions for other licensees extend to the entire
whole, and thus to each and every part regardless of who wrote it."

Is your code an independent and separate work from the Linux kernel?
Some tests might be: can it be used without the Linux kernel? Can it be
used with alternative kernels? Even if the answer to these questions is
YES (which it isn't) then that second quoted sentence would still put
your code under the terms of the GPL, since RTS OS distributes its
changes along with the Linux kernel.

I've spent enough time arguing the factual basis of this issue. It seems
crystal clear to me, and I have a hard time seeing how anyone could
disagree.

But let's forget licenses and talk community. Looking back, can anyone
say that your push to get LIO accepted into mainline as the kernel
target was in good faith? Back before LIO was merged, James chose LIO
over SCST saying to the SCST devs:

"Look, let me try to make it simple: It's not about the community you
bring to the table, it's about the community you have to join when you
become part of the linux kernel."

RTS behaved long enough to get LIO merged, and then forget community.
James is right, community is more important than code, and licenses
enforce community expectations. RTS has appeared just community-focused
enough to prevent someone else's code from being adopted, so it can
extract the benefits and still maintain its proprietary advantage.

-- Andy
