From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] convert struct scsi_varlen_cdb_hdr in scsi.h to use __u8 for user space
Date: Sun, 29 Jun 2008 07:42:56 -0600
Message-ID: <20080629134256.GK14894@parisc-linux.org>
References: <20080629210323W.fujita.tomonori@lab.ntt.co.jp> <20080629124346.GJ14894@parisc-linux.org> <20080629220206I.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:45683 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbYF2NnM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jun 2008 09:43:12 -0400
Content-Disposition: inline
In-Reply-To: <20080629220206I.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, dougg@torque.net

On Sun, Jun 29, 2008 at 10:02:03PM +0900, FUJITA Tomonori wrote:
> On Sun, 29 Jun 2008 06:43:46 -0600
> Matthew Wilcox <matthew@wil.cx> wrote:
> 
> > 
> > But we don't install anything in include/scsi to userspace:
> 
> Yeah, we don't now but it had been exported to user space, I
> guess.

I believe glibc provides /usr/include/scsi and has for some time.  Maybe
we should change that now that we have the Kbuild infrastructure to
export headers to userspace sanely.

Doug, what do you think?  You must be the biggest user of include/scsi
in userspace.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
