From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 16/17] sym53c8xx: Remove pci_dev pointer from sym_shcb
Date: Tue, 9 Oct 2007 09:27:04 -0600
Message-ID: <20071009152704.GE13842@parisc-linux.org>
References: <11916141143747-git-send-email-matthew@wil.cx> <11916141151125-git-send-email-matthew@wil.cx> <4706A79B.5060305@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58409 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbXJIP1G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Oct 2007 11:27:06 -0400
Content-Disposition: inline
In-Reply-To: <4706A79B.5060305@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

On Fri, Oct 05, 2007 at 05:07:39PM -0400, Jeff Garzik wrote:
> Obviously this is a judgement call on your part... but did you at least 
> consider passing sym_hcb for all cases instead?

I did.  There's a lot of crap stored in the sym_hcb that needs to move
to the sym_data, so Scsi_host is going to become more prevalent and
shm_hcb less used in future.  If sym2 were going to stay structured as
it is, this would be a bad move, but with the future changes I have
planned, we reach the tipping point fairly soon.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
