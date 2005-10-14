From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 4/12]  qla2xxx: Update license.
Date: Fri, 14 Oct 2005 09:27:01 -0700
Message-ID: <20051014162701.GA19098@plap.qlogic.org>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com> <20051013231614.27191.9897.sendpatchset@plap.qlogic.com> <1129275031.2873.3.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:10885 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1750781AbVJNQ1G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 12:27:06 -0400
Content-Disposition: inline
In-Reply-To: <1129275031.2873.3.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Arun Mittal <arun.mittal@qlogic.com>

On Fri, 14 Oct 2005, Arjan van de Ven wrote:
> On Thu, 2005-10-13 at 16:16 -0700, Andrew Vasquez wrote:
> > Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> 
> > +++ b/Documentation/scsi/LICENSE.qla2xxx
> > @@ -0,0 +1,59 @@
> > +Copyright (c)  2003-2005 QLogic Corporation
> > +QLogic Linux Fibre Channel HBA Driver
> > +
> > +This program includes a device driver for Linux 2.6 that may be
> > +distributed with QLogic hardware specific firmware binary file.
> > +You may modify and redistribute the device driver code under the
> > +GNU General Public License as published by the Free Software
> > +Foundation (version 2 or a later version) and/or under the
> > +following terms, as applicable:
> > +
> > +	1. Redistribution of source code must retain the above
> > +	   copyright notice, this list of conditions and the
> > +	   following disclaimer.
> > +
> > +	2. Redistribution in binary form must reproduce the above
> > +	   copyright notice, this list of conditions and the
> > +	   following disclaimer in the documentation and/or other
> > +	   materials provided with the distribution.
> > +
> > +	3. The name of QLogic Corporation may not be used to
> > +	   endorse or promote products derived from this software
> > +	   without specific prior written permission.
> > +
> 
> 
> as one of the people who made significant changes to the qlogic driver I
> object to this license change, especially because it was a one sided
> change without consultation beforehand.
> 
> James: please do not apply this.
> 
> Andrew: you can't do this. You just CANNOT change the license of code
> you don't own fully without consent of ALL contributors.

During my talk at OLS, I had mentioned that QLogic Legal was
investigating solutions to the firmware-blob licensing issue with
respect to the qla2xxx driver.  Several folks after the talk asked for
specific verbaige (which I did not have), I only knew it was going to
be a dual GPL/BSD (type) license. Later in the day I received a
preliminary copy from Legal and forwarded it to inquirying
individuals.

Since then, the license was was working its way through the
slow-moving pipelines of Legal.  During this time, it was my
understanding that the document had been vetted my several OEMs and
major distros.  Granted, I can understand that this would certainly
not get the broad exposure of the linux-kerne|scsi ditributions (which
if I'm reading correctly is one of your major concerns).  For this I
apologize, as it ultimately was my responsibility to insure this
license change proceeded smoothly.

I've since forwarded your email to our engineering VP and would also
like to solicit any others on these mailing lists for their concerns
with the license verbaige.  Given the heritage of the qla2xxx driver,
one concerns is -- at what point does one claim that total
contributors acceptance has been achieved given a proposed licensing
change.

Regards,
Andrew Vasquez


---

Copyright (c)  2003-2005 QLogic Corporation
QLogic Linux Fibre Channel HBA Driver

This program includes a device driver for Linux 2.6 that may be
distributed with QLogic hardware specific firmware binary file.
You may modify and redistribute the device driver code under the
GNU General Public License as published by the Free Software
Foundation (version 2 or a later version) and/or under the
following terms, as applicable:

	1. Redistribution of source code must retain the above
	   copyright notice, this list of conditions and the
	   following disclaimer.

	2. Redistribution in binary form must reproduce the above
	   copyright notice, this list of conditions and the
	   following disclaimer in the documentation and/or other
	   materials provided with the distribution.

	3. The name of QLogic Corporation may not be used to
	   endorse or promote products derived from this software
	   without specific prior written permission.

You may redistribute the hardware specific firmware binary file
under the following terms:

	1. Redistribution of source code (only if applicable),
	   must retain the above copyright notice, this list of
	   conditions and the following disclaimer.

	2. Redistribution in binary form must reproduce the above
	   copyright notice, this list of conditions and the
	   following disclaimer in the documentation and/or other
	   materials provided with the distribution.

	3. The name of QLogic Corporation may not be used to
	   endorse or promote products derived from this software
	   without specific prior written permission

REGARDLESS OF WHAT LICENSING MECHANISM IS USED OR APPLICABLE,
THIS PROGRAM IS PROVIDED BY QLOGIC CORPORATION "AS IS'' AND ANY
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

USER ACKNOWLEDGES AND AGREES THAT USE OF THIS PROGRAM WILL NOT
CREATE OR GIVE GROUNDS FOR A LICENSE BY IMPLICATION, ESTOPPEL, OR
OTHERWISE IN ANY INTELLECTUAL PROPERTY RIGHTS (PATENT, COPYRIGHT,
TRADE SECRET, MASK WORK, OR OTHER PROPRIETARY RIGHT) EMBODIED IN
ANY OTHER QLOGIC HARDWARE OR SOFTWARE EITHER SOLELY OR IN
COMBINATION WITH THIS PROGRAM.
