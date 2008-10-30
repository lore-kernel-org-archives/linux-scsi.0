From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] [SCSI] Create menu entry for the SCSI_WAIT_SCAN config variable
Date: Thu, 30 Oct 2008 13:17:29 -0600
Message-ID: <20081030191729.GC24469@parisc-linux.org>
References: <1225382391-8145-1-git-send-email-dmitri.vorobiev@movial.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:48819 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbYJ3TRa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 15:17:30 -0400
Content-Disposition: inline
In-Reply-To: <1225382391-8145-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Thu, Oct 30, 2008 at 05:59:51PM +0200, Dmitri Vorobiev wrote:
> The scsi_wait_scan module lacks a menu entry and help text. The
> patch adds those, and also makes the module disabled by default,
> so that it is compiled only for those targets, which consciously
> need it.

This is silly.  There is no harm in compiling this module.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
