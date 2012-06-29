From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] fcoe: fix compilation warnings of section mismatch
Date: Fri, 29 Jun 2012 21:20:28 +0100
Message-ID: <1341001228.2907.61.camel@dabdike.int.hansenpartnership.com>
References: <1340713062-126798-1-git-send-email-antonz@parallels.com>
	 <4FEE0C55.6010704@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47550 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932268Ab2F2UUb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jun 2012 16:20:31 -0400
In-Reply-To: <4FEE0C55.6010704@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Love, Robert W" <robert.w.love@intel.com>
Cc: Tony Zelenoff <antonz@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2012-06-29 at 20:13 +0000, Love, Robert W wrote:
> On 12-06-26 05:17 AM, Tony Zelenoff wrote:
> 
> Fix this message:
> WARNING: drivers/scsi/fcoe/libfcoe.o(.init.text+0x21): Section mismatch
> in reference from the function init_module() to the function
> .exit.text:fcoe_transport_exit()
> The function __init init_module() references
> a function __exit fcoe_transport_exit().
> 
> Signed-off-by: Tony Zelenoff <antonz@parallels.com><mailto:antonz@parallels.com>
> 
> 
> Thank you for the patch. However, this was fixed a few weeks ago. The patch is in James' 'for-next' branch here: http://git.kernel.org/?p=linux/kernel/git/jejb/scsi.git;a=commit;h=43b8a1613a1c8707d0e86316a7d6999fd767a5cf
> 
> I'm not sure if it's queue'd up for the current RC phase or not. I don't know how the scsi.git branches are managed. I think the patch should go for the current RC.

Show me the bug it actually produces and I'll queue it for -rc ...

James


