From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [PATCH] 2.6.1-rc2 - MPT Fusion driver 3.00.00 update
Date: Tue, 6 Jan 2004 22:40:01 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040106224001.A27675@lists.us.dell.com>
References: <3FFB4E0F.704@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lists.us.dell.com ([143.166.224.162]:43444 "EHLO
	lists.us.dell.com") by vger.kernel.org with ESMTP id S266069AbUAGEkN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jan 2004 23:40:13 -0500
Content-Disposition: inline
In-Reply-To: <3FFB4E0F.704@lsil.com>; from emoore@lsil.com on Tue, Jan 06, 2004 at 05:08:47PM -0700
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 'James.Bottomley@steeleye.com'

On Tue, Jan 06, 2004 at 05:08:47PM -0700, Eric Moore wrote:
> Here's an driver update for mpt fusion driver version 3.00.00.

Eric, since this is for 2.6.x, need the driver export anything in
/proc anymore, preferring to export via sysfs instead?

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
