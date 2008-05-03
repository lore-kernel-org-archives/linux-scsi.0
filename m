From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SCSI target subsystem
Date: Sat, 3 May 2008 03:53:14 -0600
Message-ID: <20080503095314.GX14976@parisc-linux.org>
References: <200805021638.42972.bart.vanassche@gmail.com> <20080502153306.GB7376@infradead.org> <e2e108260805020853r4c21fb98y3d4434a7fc95989c@mail.gmail.com> <20080502155525.GA16353@infradead.org> <e2e108260805020906w7f5e92bev46b8d0f96aa7b4d6@mail.gmail.com> <1209745084.3121.39.camel@localhost.localdomain> <481B5AB8.5030108@vlnb.net> <e2e108260805030241w216363dbt4b5f6b2105ad267b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43591 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbYECJxb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 May 2008 05:53:31 -0400
Content-Disposition: inline
In-Reply-To: <e2e108260805030241w216363dbt4b5f6b2105ad267b@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: FUJITA Tomonori <tomof@acm.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>

On Sat, May 03, 2008 at 11:41:41AM +0200, Bart Van Assche wrote:
> On Fri, May 2, 2008 at 8:17 PM, Vladislav Bolkhovitin <vst@vlnb.net> wrote:
> > I wrote all above to support my at first glance shocking conclusion that
> > SCSI target subsystem is completely new subsystem of the kernel and it
> > should live on its own with its own maintainer! This is the same as with the
> > current interaction between SCSI and block subsystems in the kernel: SCSI
> > uses block's functionality, but that doesn't mean that block and SCSI are
> > the same subsystem.
> 
> Hello Tomo,
> 
> Due to the IET and STGT projects you have a lot of experience with
> implementing SCSI target frameworks. What is your opinion about how a
> kernel space SCSI target framework should fit in the Linux kernel ?

Bart, what is your role in the SCST project?  You don't seem to have
contributed any code to it (going by the SVN logs on sourceforge), and
your questions and suggestions seem to be those of someone not familiar
with the code.  If you're not a developer, it might be more helpful for
you to step back and let Vladislav handle this.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
