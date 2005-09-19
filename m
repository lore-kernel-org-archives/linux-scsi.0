From: Anton Blanchard <anton@samba.org>
Subject: Re: scsi error handling oops on current git
Date: Tue, 20 Sep 2005 02:35:09 +1000
Message-ID: <20050919163509.GE25588@krispykreme>
References: <20050919155245.GD25588@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:56231 "EHLO ozlabs.org")
	by vger.kernel.org with ESMTP id S932469AbVISQjB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2005 12:39:01 -0400
Content-Disposition: inline
In-Reply-To: <20050919155245.GD25588@krispykreme>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

> I managed to hit this on a screwy setup (bad interrupt routing). Its the 
> sym2 driver.
> 
> It looks like the error handler thread freed the same sgtable twice.
> Second time through we mempool_free on a NULL pointer and die.

I just pulled in scsi-rc-fixes and it looks to be fixed. Will test more 
after some sleep.

Anton
