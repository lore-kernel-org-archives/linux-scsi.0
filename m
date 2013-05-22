From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Wed, 22 May 2013 14:11:35 -0400
Message-ID: <20130522181135.GC20848@thunk.org>
References: <20130522093249.GC3466@mtj.dyndns.org>
 <519C959A.3090100@redhat.com>
 <20130522100212.GE3466@mtj.dyndns.org>
 <519C9CBC.3050003@redhat.com>
 <20130522134134.GA15189@mtj.dyndns.org>
 <519CD234.40608@redhat.com>
 <20130522150335.GC2777@thunk.org>
 <519CE9FE.2030007@redhat.com>
 <yq1vc6b561q.fsf@sermon.lab.mkp.net>
 <519CF99E.6010804@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <519CF99E.6010804@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 22, 2013 at 07:00:14PM +0200, Paolo Bonzini wrote:
> You have hardware providers selling cloud services that want to run
> their own custom backup services from within a VM, which entails having
> vendor-specific commands run from within a VM.  Or you have people that
> run clusters that are half-physical and half-virtual and want to use the
> same /dev/disk/by-id paths in both cases; perhaps, with NPIV, they want
> to use one zoning approach for both physical and virtual machines.
> Someone else they want to backup to tapes from a VM (for example s390
> people who just put everything in a VM, so the distinction of physical
> and virtual makes no sense for them).  Some people use virtual machines
> as sandboxes, and want to burn the ISOs from the same VMs where they
> download the ISOs.  Some people have vendor utilities that only run
> under Windows, and want to run them in a VM.

So is this hypothetical or do you have a real customer in mind?  If
it's not theoretical, how does the cloud service control who has
access to the CD burner, and how are the disks loaded into the CD
burner?  Trying to do it where you run cdrecord from the guest OS
sounds **insane**.  The far better way of doing things is to export a
web service where you ship a iso image plus a shipping address to a
burn service, and you don't try to figure out how to make dozens of VM
on a cloud server share a physical CD burner attached to a physical
host OS.  That way leads to insanity.

						- Ted
