From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] fc_transport: fix sysfs deadlock on vport delete
Date: Tue, 22 May 2007 10:42:12 -0500
Message-ID: <1179848532.3738.15.camel@mulgrave.il.steeleye.com>
References: <1177692740.26526.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:39399 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758268AbXEVPmO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2007 11:42:14 -0400
In-Reply-To: <1177692740.26526.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Fri, 2007-04-27 at 12:52 -0400, James Smart wrote:
> When the vport attribute "delete" is used to delete the vport, sysfs
> deadlocks waiting for the write to complete, which is waiting for the
> sysfs teardown to complete. Moved this effort to a work_q element.
> 
> Took the opportunity to make some other cosmetic changes:
>  - removed tabs in Doc file - replaced with expanded spaces
>  - minor copyright text and author text updates
>  - removed a bunch of trailing whitespace

This one rejects against scsi-misc, could you reroll

(I suspect because the prior vport patch had spacing errors which git
makes me fix before I commit).

James


