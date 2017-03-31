From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthrough commands
Date: Fri, 31 Mar 2017 21:27:59 +0200
Message-ID: <20170331192759.GA9744@kroah.com>
References: <20170331135030.GA24063@zipoli.ccur.kvm>
 <20170331141229.GB8141@kroah.com>
 <20170331141647.GA26310@zipoli.ccur.kvm>
 <20170331145052.GA15647@kroah.com>
 <20170331181029.GA13098@zipoli.ccur.kvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170331181029.GA13098@zipoli.ccur.kvm>
Sender: stable-owner@vger.kernel.org
To: Joe Korty <joe.korty@ccur.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrey Grodzovsky <andrey2805@gmail.com>, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Ingo Molnar <mingo@kernel.org>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Stable Mailing List <stable@vger.kernel.org>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 31, 2017 at 02:10:29PM -0400, Joe Korty wrote:
> On Fri, Mar 31, 2017 at 04:50:52PM +0200, Greg Kroah-Hartman wrote:
> > A: Because it messes up the order in which people normally read text.
> > Q: Why is top-posting such a bad thing?
> > A: Top-posting.
> > Q: What is the most annoying thing in e-mail?
> > 
> > A: No.
> > Q: Should I include quotations after my reply?
> > 
> > 
> > http://daringfireball.net/2007/07/on_top
> > 
> > On Fri, Mar 31, 2017 at 10:16:47AM -0400, Joe Korty wrote:
> > > Hi Greg,
> > > This patch is not yet in 4.4.
> > 
> > What patch is that?  I can't find a git commit id here at all :(
> > 
> > > It is in 4.9 and upstream.  No one has submitted it to you before this
> > > email.  I only discovered the need for it because lockdep complains
> > > when it is missing.  I do not know how it was missed; perhaps there is
> > > a reason rather than it being missed by accident. Others in the know
> > > can comment if they like.
> > 
> > You need to say what you want to have happen for a stable patch, you did
> > read Documenation/stable_kernel_rules.txt, right?
> > 
> > still confused,
> > 
> > greg k-h
> 
> 
> Hi Greg,
> The patch is one that has already been backported into 4.9,
> and as such I assumed it was already in a format acceptable
> for submission.
> 
> 4.4 is the only additional branch that needs this patch,
> and there it is needed only because in 4.4.28 two other
> mpt3sas patches had been backported.  Those two patches
> introduced the lock dependency problem that this, the
> third patch, fixes.
> 
> In summary, either all three patches should be backported,
> or none should be backported.  Porting just two is wrong.

What patches?  Please start over, resend the email in a format that can
be understand as to what commits you want added to what stable kernel
tree. As it is, I still have no clue...

greg k-h
