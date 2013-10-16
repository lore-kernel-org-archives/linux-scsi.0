From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug] 12.864681  BUG: lock held when returning to user space!
Date: Wed, 16 Oct 2013 14:24:57 +0100
Message-ID: <1381929897.1864.0.camel@dabdike>
References: <8761tilrl0.fsf@redhat.com> <874n8s2tjz.fsf@redhat.com>
	 <5253A9E7.5030707@oracle.com> <52540C7F.8050207@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52540C7F.8050207@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: vaughan <vaughan.cao@oracle.com>, Madper Xie <cxie@redhat.com>, linux-kernel@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-10-08 at 09:45 -0400, Douglas Gilbert wrote:
> On 13-10-08 02:44 AM, vaughan wrote:
> > Hi Madper,
> >
> > CC to Douglas to get comments.
> > I use the rw_semaphore o_sem to protect excl open, introduced in commit
> > 15b06f9a02406e5460001db6d5af5c738cd3d4e7 since v3.12-rc1.
> > Is it forbidden to do like that in kernel?...
> 
> It appears you can not (allow sg_open() to hold a semaphore
> then return to the user space). So you will need to do some
> rework on that patch or revert it.

OK, there being no reply on this, I'll do the revert ... that's all four
patches, correct?

James
