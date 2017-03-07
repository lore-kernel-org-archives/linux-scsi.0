From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] scsi: lpfc: Add shutdown method for kexec
Date: Tue, 07 Mar 2017 16:24:22 +1100
Message-ID: <1488864262.2870.149.camel@kernel.crashing.org>
References: <20170212214920.28866-1-anton@ozlabs.org>
         <e13aeaf9-3b2c-a9e8-5867-cf9ab20a040c@linux.vnet.ibm.com>
         <yq1lgshkau0.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:41733 "EHLO gate.crashing.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750728AbdCGFpM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 7 Mar 2017 00:45:12 -0500
In-Reply-To: <yq1lgshkau0.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: Anton Blanchard <anton@ozlabs.org>, james.smart@broadcom.com, dick.kennedy@broadcom.com, jejb@linux.vnet.ibm.com, jk@ozlabs.org, linux-scsi@vger.kernel.org

On Mon, 2017-03-06 at 22:46 -0500, Martin K. Petersen wrote:
> > > > > > "Mauricio" == Mauricio Faria de Oliveira <mauricfo@linux.vn
> > > > > > et.ibm.com> writes:
> 
> Mauricio> On 02/12/2017 07:49 PM, Anton Blanchard wrote:
> > > We see lpfc devices regularly fail during kexec. Fix this by
> > > adding a
> > > shutdown method which mirrors the remove method.
> 
> Mauricio> @mkp, @jejb: may you please flag this patch for
> stable?  Thank
> Mauricio> you.
> 
> I don't recall a consensus being reached on this patch.

What would be the opposition ? Without it kexec breaks. With it, it
works ...

Now we all seem to agree that kexec should be overhauled to not use
shutdown but instead unbind drivers, but that's a more long term
project that nobody yet had a chance to tackle.

In the meantime, some systems need a functioning kexec to boot.

Cheers,
Ben.
