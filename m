From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] scsi: mpt3sas: fix hang on ata passthrough commands
Date: Fri, 31 Mar 2017 16:50:52 +0200
Message-ID: <20170331145052.GA15647@kroah.com>
References: <20170331135030.GA24063@zipoli.ccur.kvm>
 <20170331141229.GB8141@kroah.com>
 <20170331141647.GA26310@zipoli.ccur.kvm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170331141647.GA26310@zipoli.ccur.kvm>
Sender: stable-owner@vger.kernel.org
To: Joe Korty <joe.korty@ccur.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrey Grodzovsky <andrey2805@gmail.com>, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Ingo Molnar <mingo@kernel.org>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux Stable Mailing List <stable@vger.kernel.org>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

A: No.
Q: Should I include quotations after my reply?


http://daringfireball.net/2007/07/on_top

On Fri, Mar 31, 2017 at 10:16:47AM -0400, Joe Korty wrote:
> Hi Greg,
> This patch is not yet in 4.4.

What patch is that?  I can't find a git commit id here at all :(

> It is in 4.9 and upstream.  No one has submitted it to you before this
> email.  I only discovered the need for it because lockdep complains
> when it is missing.  I do not know how it was missed; perhaps there is
> a reason rather than it being missed by accident. Others in the know
> can comment if they like.

You need to say what you want to have happen for a stable patch, you did
read Documenation/stable_kernel_rules.txt, right?

still confused,

greg k-h
