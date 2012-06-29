From: "Love, Robert W" <robert.w.love@intel.com>
Subject: Re: [PATCH] fcoe: fix compilation warnings of section mismatch
Date: Fri, 29 Jun 2012 20:13:05 +0000
Message-ID: <4FEE0C55.6010704@intel.com>
References: <1340713062-126798-1-git-send-email-antonz@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:30366 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab2F2UNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jun 2012 16:13:12 -0400
In-Reply-To: <1340713062-126798-1-git-send-email-antonz@parallels.com>
Content-Language: en-US
Content-ID: <5B018E466BFCE248BAB345650A272BFF@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Zelenoff <antonz@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 12-06-26 05:17 AM, Tony Zelenoff wrote:

Fix this message:
WARNING: drivers/scsi/fcoe/libfcoe.o(.init.text+0x21): Section mismatch
in reference from the function init_module() to the function
.exit.text:fcoe_transport_exit()
The function __init init_module() references
a function __exit fcoe_transport_exit().

Signed-off-by: Tony Zelenoff <antonz@parallels.com><mailto:antonz@parallels.com>


Thank you for the patch. However, this was fixed a few weeks ago. The patch is in James' 'for-next' branch here: http://git.kernel.org/?p=linux/kernel/git/jejb/scsi.git;a=commit;h=43b8a1613a1c8707d0e86316a7d6999fd767a5cf

I'm not sure if it's queue'd up for the current RC phase or not. I don't know how the scsi.git branches are managed. I think the patch should go for the current RC.

//Rob

