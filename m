From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [scsi:for-next 14/27] drivers/scsi/qla2xxx/qla_os.c:364
 qla2x00_free_req_que() info: redundant null check on req->outstanding_cmds
 calling kfree()
Date: Tue, 29 Jan 2013 13:59:37 +1100
Message-ID: <1359428377.2408.20.camel@dabdike>
References: <50cf1402.D18vi8fJJPt89aXx%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41778 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750874Ab3A2C7m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jan 2013 21:59:42 -0500
In-Reply-To: <50cf1402.D18vi8fJJPt89aXx%fengguang.wu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, linux-scsi@vger.kernel.org, Saurav Kashyap <saurav.kashyap@qlogic.com>

On Mon, 2012-12-17 at 20:45 +0800, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> head:   e3ff197a750d2912d0bb2a0161c23c18bad250ad
> commit: 99cc149bbdd78a3f18c6b366e1c239f62d59d096 [14/27] [SCSI] qla2xxx: Determine the number of outstanding commands based on available resources.
> 
> 
> smatch warnings:
> 
> + drivers/scsi/qla2xxx/qla_os.c:364 qla2x00_free_req_que() info: redundant null check on req->outstanding_cmds calling kfree()
>   drivers/scsi/qla2xxx/qla_os.c:686 qla2xxx_queuecommand() error: potential NULL dereference 'rport'.

I flushed all the outstanding qla2xxx patches from the SCSI tree.
Please fix these issues and resubmit.

Thanks,

James


