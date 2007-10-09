From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 04/21] advansys: Fix simultaneous calls to ->queuecommand
Date: Tue, 9 Oct 2007 07:27:56 -0600
Message-ID: <20071009132756.GD13842@parisc-linux.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <11913765423981-git-send-email-matthew@wil.cx> <470A0173.7000603@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:33317 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbXJIN15 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Oct 2007 09:27:57 -0400
Content-Disposition: inline
In-Reply-To: <470A0173.7000603@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

On Mon, Oct 08, 2007 at 12:07:47PM +0200, Boaz Harrosh wrote:
> I see that these patches are before the conversion to scsi data accessors 
> and !use_sg cleanup that was posted by TOMO:
> http://www.spinics.net/lists/linux-scsi/msg19055.html
> 
> Could you please also post that patch rebased to latest changes as part of
> your patchset?

That was patch 18/21

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
