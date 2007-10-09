From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 11/17] sym53c8xx: Remove tag_ctrl module parameter
Date: Tue, 9 Oct 2007 09:35:00 -0600
Message-ID: <20071009153500.GG13842@parisc-linux.org>
References: <11916141143747-git-send-email-matthew@wil.cx> <11916141152123-git-send-email-matthew@wil.cx> <4706A509.4070608@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52501 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbXJIPfB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Oct 2007 11:35:01 -0400
Content-Disposition: inline
In-Reply-To: <4706A509.4070608@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

On Fri, Oct 05, 2007 at 04:56:41PM -0400, Jeff Garzik wrote:
> Matthew Wilcox wrote:
> >With sysfs making these options tunable at runtime, there's no
> >justification for keeping this horrendously complex specification
> >string around.
> >
> >Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> >---
> > Documentation/scsi/sym53c8xx_2.txt   |   21 +++--------
> > drivers/scsi/sym53c8xx_2/sym53c8xx.h |    1 -
> > drivers/scsi/sym53c8xx_2/sym_glue.c  |   66 
> > ++--------------------------------
> > 3 files changed, 8 insertions(+), 80 deletions(-)
> 
> ACK presuming you are convinced this will not break anybody in the field

Yeah, I am.  When Rusty did the conversion of sym53c8xx="..." to
individual module params, I didn't hear a single complaint.  I feel sure
nobody's using these options any more.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
