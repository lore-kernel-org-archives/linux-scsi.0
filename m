From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH 0/8] bfa: update bfa driver to version 2.1.2.1 (resubmit)
Date: Wed, 16 Dec 2009 19:55:24 -0800
Message-ID: <04391A4E90BB2149B010D22452FA16875EF12BFE@HQ-EXCH-6.corp.brocade.com>
References: <1259545058-4358-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.83]:52062 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757873AbZLQDz1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2009 22:55:27 -0500
In-Reply-To: <1259545058-4358-1-git-send-email-huangj@brocade.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@Brocade.COM>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.COM>

Hi James,

What is the status of this patch set? Is there anything I can do in order to get it accepted in 2.6.33 merger window?

Thanks

Jing

> -----Original Message-----
> From: Jing Huang
> Sent: Sunday, November 29, 2009 5:38 PM
> To: James.Bottomley@suse.de; linux-scsi@vger.kernel.org
> Cc: Adapter Linux Open SRC Team; Jing Huang
> Subject: [PATCH 0/8] bfa: update bfa driver to version 2.1.2.1 (resubmit)
> 
> Hi James,
> 
> I went through our internal code checkin logs and bug tracker records for
> 2.1
> driver, and here is a summary of the changes:
> 
>  - Update driver to version 2.1.2.1
>  - Fixed various IOC down issues in driver and firmware.
>  - IOC state machine fixes.
>  - Fixed issues in IOC auto recovery.
>  - Hardware/firmware related fixes.
>  - FC state machine fixes.
>  - Added more stats for FC and fixed issues in FCOE stats collection
>  - Vport fixes.
>  - Added new portlog entries for events and enhanced bfa loging.
>  - Renamed port data structures to avoid confusion between driver and
> firmware.
>  - code reorganizations and cleanups.
> 
> 2.1 driver is our latest major release. The development and testing cycle
> has
> spanned for several months, and there have been numerous checkins for both
> bug
> fixes and cleanups. Clearly splitting them is very difficult and also
> error-prone. For this reason, I still include all the changes we have made
> to
> 2.1 in one patch set instead of splitting them into multiple ones.
> 
> Going forward, the upstream driver will be in sync with our latest
> internal
> development, so we wil be able to submit patches that are specific
> to bug fixe or code cleanup.
> 
> As you suggested, this patch set is based off a combination of scsi-misc-
> 2.6
> and Linus's upstream tree, and it is intended to be include in 2.6.33
> merger
> window.
> 
> Thanks
> 
> Jing
> 
> Signed-off-by: Jing Huang <huangj@brocade.com>
