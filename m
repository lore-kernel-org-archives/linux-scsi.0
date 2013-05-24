From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH v5 0/2] block,scsi: fixup blk_get_request dead queue
 scenarios
Date: Fri, 24 May 2013 14:15:31 -0400
Message-ID: <20130524141531.737073a8@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1303171328250.1736@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub5.stratus.com ([134.111.1.18]:57401 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3EXSTS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 May 2013 14:19:18 -0400
In-Reply-To: <alpine.DEB.2.02.1303171328250.1736@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Joe Lawrence <Joe.Lawrence@stratus.com>, Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jkosina@suse.cz>, "James E.J. Bottomley" <JBottomley@parallels.com>, Bart Van Assche <bvanassche@acm.org>

[PATCH v5 0/2] block,scsi: fixup blk_get_request dead queue scenarios

Changes from v4:

 - As per James' suggestion, split into two patches: the first adds
   blk_get_request return value checking to avoid potential oops, the
   second converts callers and friends to handle ERR_PTR differentiation
   of -ENOMEM and -ENODEV.

Regards,

-- Joe
