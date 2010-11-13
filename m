From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] SCSI queuecommand API change for 2.6.37-rc1
Date: Fri, 12 Nov 2010 16:38:08 -0800
Message-ID: <1289608688.22107.9.camel@haakon2.linux-iscsi.org>
References: <1289606118.3015.539.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:42111 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab0KMAnU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Nov 2010 19:43:20 -0500
In-Reply-To: <1289606118.3015.539.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Fri, 2010-11-12 at 17:55 -0600, James Bottomley wrote:
> This patch set contains a single patch modifying the SCSI queuecommand
> host template API to go from being called with the host lock held to
> being called locklessly.  The transformation is a directly equivalent
> one (i.e. the locking is simply pushed into each HBA) but will form the
> basis for optimising locking in the driver patch for the next merge
> window.
> 
> The patch is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> 
> The short changelog is:
> 
> Jeff Garzik (1):
>       host lock push-down
> 

Hi James and Co,

Please feel free to add my review signoff for jgarzik's work.

Thanks!

Reviewed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

