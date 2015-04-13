From: "Gilad Broner" <gbroner@codeaurora.org>
Subject: re: ufs: add ioctl interface for query request
Date: Mon, 13 Apr 2015 10:55:58 -0000
Message-ID: <bad58376cabac273fbe5a8ea22356204.squirrel@www.codeaurora.org>
References: <20150409201755.GA9651@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43045 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbbDMKz6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2015 06:55:58 -0400
In-Reply-To: <20150409201755.GA9651@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: draviv@codeaurora.org, linux-scsi@vger.kernel.org

> copy_to/from_user() returns the number of bytes not copied and not an
> error code.  Printing these error messages in the ioctl means the user
> can trigger a DoS by filling up /var/log/messages.  They make the code
> uglier.  We should stop here if the copy fails and goto out_release_mem
> otherwise we might end up returning success by mistake.

Thanks for the comment, I will update the code.
I wanted to clarify about the possibility of a DoS attack:
- Isn't var/log/messages cyclic or size limited in some way?
- What determines that dev_err() prints go to /var/log/messages?
  would it still be the case if dev_dbg() was used instead?

Thanks,
Gilad.



-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

