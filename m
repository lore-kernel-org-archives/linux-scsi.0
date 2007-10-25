From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Correct tag initialisation for commands
Date: Thu, 25 Oct 2007 05:40:33 -0600
Message-ID: <20071025114033.GM27248@parisc-linux.org>
References: <4718AFD7.5000203@suse.de> <4718F000.6020104@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:53641 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756654AbXJYLke (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Oct 2007 07:40:34 -0400
Content-Disposition: inline
In-Reply-To: <4718F000.6020104@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Hannes Reinecke <hare@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Oct 19, 2007 at 12:57:20PM -0500, Mike Christie wrote:
> If every ones uses the scsi_tcq wrappers, maybe the scsi_cmnd->tag field 
> would be something that could be deleted and help Mathew's goals to 
> shrink the struct.

It's something I'd thought about, but we don't have any other 'char'
sized pieces of data in the scsi_cmnd, and they're all nicely packed
together, so it won't save us anything today.  If we want to get rid of
it for other reasons, that's fine, of course ;-)

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
