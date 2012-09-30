From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH][SCSI] mpt3sas: Paer 1 of MPI API headers
Date: Sat, 29 Sep 2012 19:50:28 -0600
Message-ID: <20120930015027.GA28918@parisc-linux.org>
References: <20120929140743.GA20622@localhost.localdomain> <878vbsy2jg.fsf@nemi.mork.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:55412 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab2I3CAz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2012 22:00:55 -0400
Content-Disposition: inline
In-Reply-To: <878vbsy2jg.fsf@nemi.mork.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bj??rn Mork <bjorn@mork.no>
Cc: sreekanth.reddy@lsi.com, linux-scsi@vger.kernel.org, jejb@kernel.org, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com

On Sat, Sep 29, 2012 at 10:52:50PM +0200, Bj??rn Mork wrote:
> <sreekanth.reddy@lsi.com> writes:
> > This patch contains MPI API headers
> 
> Why can't this and the other headers be shared between the mpt2sas and
> mpt3sas drivers?  Looks like you are duplicating a lot of code already
> present in drivers/scsi/mpt2sas.  Why?  That's a recipe for maintenance
> hell...

I would go further and ask why this needs a new driver; why can't mpt2sas
be enhanced to drive the 12Gbit cards?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
