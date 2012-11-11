From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: scsi target, likely GPL violation
Date: Sun, 11 Nov 2012 09:34:16 +0000
Message-ID: <1352626456.6524.46.camel@dabdike>
References: <509A915B.30105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <509A915B.30105@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Marc Fleischmann <mwf@risingtidesystems.com>, Nicholas Bellinger <nab@risingtidesystems.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-11-07 at 08:50 -0800, Andy Grover wrote:
> Nick,
> 
> Your company appears to be shipping kernel features in RTS OS that are
> not made available under the GPL, specifically support for the
> EXTENDED_COPY and COMPARE_AND_WRITE SCSI commands, in order to claim
> full Vmware vSphere 5 VAAI support.
> 
> http://www.risingtidesystems.com/storage.html
> http://www.linux-iscsi.org/wiki/VAAI
> 
> Private emails to you and RTS CEO Marc Fleischmann have not elicited a
> useful response.
> 
> You are subsystem maintainer for the in-kernel SCSI target support
> (drivers/target/*), and your company appears to be violating the GPL.
> Please explain.

Can we please cool it with the inflammatory accusations.  Please
remember that statements which damage or seek to damage the reputation
of a company amount to libel even under US law ... and using phrases
like "appears to" doesn't shield you from this.

I also note that whatever their website says RTS OS isn't in VMware's
certified compatibility list:

http://www.vmware.com/resources/compatibility/pdf/vi_io_guide.pdf

Plus it's a grey area what you actually have to support to make that
list (especially as XCOPY has now been removed from SBC-3 in favour of
token copy), so I'd say that the chain of reasoning you've used to come
up with this hearsay allegation of copyright violation is tenuous at
best.

Anybody who does enforcement will tell you that you begin with first
hand proof of a violation.  That means obtain the product and make sure
it's been modified and that a request for corresponding source fails.
In this case, since I presume Red Hat, as a RTS partner, has a bona fide
copy of the RTS OS, please verify it does indeed implement or issue the
commands which are not in the public git repository and that whoever
owns the copy makes a request for the source code.

I would really appreciate it if the next email I see from you on this
subject is either

     1. Yes, I've got first hand proof of a GPL violation (in which case
        we'll then move to seeing how we can remedy this) or
     2. A genuine public apology for the libel, which I'll do my best to
        prevail on RTS to accept.

Because any further discussion of unsubstantiated allegations of this
nature exposes us all to jeopardy of legal sanction.

James
