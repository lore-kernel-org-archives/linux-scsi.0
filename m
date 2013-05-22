From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: PING^7 (was Re: [PATCH v2 00/14] Corrections and customization
 of the SG_IO command whitelist (CVE-2012-4542))
Date: Wed, 22 May 2013 16:19:57 -0400
Message-ID: <20130522201957.GD20848@thunk.org>
References: <20130522100212.GE3466@mtj.dyndns.org>
 <519C9CBC.3050003@redhat.com>
 <20130522134134.GA15189@mtj.dyndns.org>
 <519CD234.40608@redhat.com>
 <20130522150335.GC2777@thunk.org>
 <519CE9FE.2030007@redhat.com>
 <yq1vc6b561q.fsf@sermon.lab.mkp.net>
 <519CF99E.6010804@redhat.com>
 <20130522181135.GC20848@thunk.org>
 <519D1E92.7030505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50906 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752843Ab3EVUUH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 May 2013 16:20:07 -0400
Content-Disposition: inline
In-Reply-To: <519D1E92.7030505@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Tejun Heo <tj@kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, May 22, 2013 at 09:37:54PM +0200, Paolo Bonzini wrote:
> > If it's not theoretical, how does the cloud service control who has
> > access to the CD burner, and how are the disks loaded into the CD
> > burner?
> 
> CD burning would be used in a VM that runs on your local workstation, so
> the VM gets access to the CD burner under your desk.  There was also a
> developer of a CD burning tool that wanted to test it inside BSD,
> Solaris and Windows VMs; the idea is the same.

So in both cases all of the VM's and the host OS are within the same
trust boundary.  This simplifies the security requirements than in the
more generic cloud server caser where the VM's are mutually
suspicious.  This simplifies the requirements of what we need to push
into the kernel, yes?

						- Ted
