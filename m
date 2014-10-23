From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: ufs: add UFS power management support
Date: Thu, 23 Oct 2014 13:06:30 +0300
Message-ID: <20141023100630.GI26918@mwanda>
References: <20141002153112.GB11534@mwanda>
 <009c01cfee93$00a96b60$01fc4220$@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46820 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbaJWKGo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Oct 2014 06:06:44 -0400
Content-Disposition: inline
In-Reply-To: <009c01cfee93$00a96b60$01fc4220$@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dolev Raviv <draviv@codeaurora.org>
Cc: subhashj@codeaurora.org, linux-scsi@vger.kernel.org

On Thu, Oct 23, 2014 at 10:28:52AM +0300, Dolev Raviv wrote:
> Hi Dan,
> This seem like a false alarm, please let me know if it requires a fix.
> 

It may not indicate a bug, but it is correct in that the code could be
re-written:

Old:

	else if ((req_link_state == UIC_LINK_OFF_STATE) &&
		(!check_for_bkops || (check_for_bkops &&
		!hba->auto_bkops_enabled))) {

Proposed:

	else if ((req_link_state == UIC_LINK_OFF_STATE) &&
		 (!check_for_bkops || !hba->auto_bkops_enabled)) {

Those two are the same.

regards,
dan carpenter


