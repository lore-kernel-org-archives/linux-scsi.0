From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC: 2.6 patch] nsp32_restart_autoscsi(): remove error check
Date: Wed, 24 Oct 2007 12:41:12 -0400
Message-ID: <1193244072.3396.17.camel@localhost.localdomain>
References: <20071024162515.GV30533@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:59585 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763472AbXJXQlS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Oct 2007 12:41:18 -0400
In-Reply-To: <20071024162515.GV30533@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: yokota@netlab.is.tsukuba.ac.jp, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2007-10-24 at 18:25 +0200, Adrian Bunk wrote:
> The Coverity checker noted that we'll anyway Oops later when we ran into 
> this condition - and the error check didn't prevent that.
> 
> Considering that the error condition shouldn't be possible, and we are 
> not able to handle it easily, this patch simply removes the pointless 
> error check.

This is the one where I said I don't like the fact that you're removing
the explanatory message that's printed before we crash.  if you want to
shut coverity up and stop sending the patch, I'm happy adding a BUG();
after the nsp32_msg().

James


