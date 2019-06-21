From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v1] scsi: Don't select SCSI_PROC_FS by default
Date: Sat, 22 Jun 2019 09:50:24 +1000 (AEST)
Message-ID: <alpine.LNX.2.21.1906220920320.180@nippy.intranet>
References: <2de15293-b9be-4d41-bc67-a69417f27f7a@free.fr> <621306ee-7ab6-9cd2-e934-94b3d6d731fc@acm.org> <fb2d2e74-6725-4bf2-cf6c-63c0a2a10f4f@interlog.com> <alpine.LNX.2.21.1906181107240.287@nippy.intranet> <017cf3cf-ecd8-19c2-3bbd-7e7c28042c3c@free.fr>
 <f8339103-5b45-b72d-9f87-fd4dd7b3081e@interlog.com> <f1f98ab0-399a-6c12-073d-ee8ad47d5588@free.fr> <48912bc0-8c79-408d-7ed2-c127b99b8bcc@interlog.com> <e04e14b7-e1ee-c0c1-9e6d-2628d2c873a9@free.fr> <alpine.LNX.2.21.1906210942560.131@nippy.intranet>
 <5d9d0851-f864-6d78-7e7d-9d018bea5704@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5d9d0851-f864-6d78-7e7d-9d018bea5704@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Gonzalez <marc.w.gonzalez@free.fr>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Bart Van Assche <bvanassche@acm.org>, James Bottomley <jejb@linux.ibm.com>, Martin Petersen <martin.petersen@oracle.com>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Fri, 21 Jun 2019, Marc Gonzalez wrote:

> On 21/06/2019 01:43, Finn Thain wrote:
> 
> > On Thu, 20 Jun 2019, Marc Gonzalez wrote:
> > 
> >> How likely is it that distro kernels would *not* enable CHR_DEV_SG? 
> >> (Distros tend to enable everything, and then some.)
> > 
> > How likely is it that embedded developers would *not* disable 
> > CHR_DEV_SG? They tend to disable everything, and then enable only what 
> > they need.
> 
> I don't see where you're going with this line of reasoning?
> 

Exactly. This sort of reasoning goes nowhere.

> Below is my current (as of next-20190612) defconfig.
> 
> Notice the options marked as "not set". These are options that are 
> enabled by default (and which I've disabled).
> 
> Everyone thinks "their" option is critical (and it is, *to them*) but, 
> in fact, few really are -- universally. 

The relevant policy is documented in 
Documentation/kbuild/kconfig-language.txt.

If there are useful generalizations about the choice of defaults for 
Kconfig symbols (or changing those defaults) that are not documented then 
they probably should be.

-- 
