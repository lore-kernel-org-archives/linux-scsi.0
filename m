From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/2] bnx2i: Updates for scsi "misc" branch
Date: Tue, 19 May 2015 10:41:17 -0500
Message-ID: <555B599D.4010201@cs.wisc.edu>
References: <1432028924-25788-1-git-send-email-nilesh.javali@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34154 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755456AbbESP41 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2015 11:56:27 -0400
In-Reply-To: <1432028924-25788-1-git-send-email-nilesh.javali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nilesh.javali@qlogic.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: giridhar.malavali@qlogic.com, QLogic-Storage-Upstream@qlogic.com

On 5/19/15, 4:48 AM, nilesh.javali@qlogic.com wrote:
> From: Nilesh Javali <nilesh.javali@qlogic.com>
>
> The following set of patches are bug fixes for bnx2i driver.
> Please apply the following patches to the scsi tree at your earliest convenience.
>
> Nilesh Javali (1):
>        bnx2i: Fix call trace while device reset
>
> Tej Parkash (1):
>        bnx2i: Fixed firmware assert, during target logout.
>
>   drivers/scsi/bnx2i/bnx2i_iscsi.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>

Looks ok to me.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
