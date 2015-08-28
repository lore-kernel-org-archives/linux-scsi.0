From: Wendy Xiong <wenxiong@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] ipr: Inhibit underlength data check for AFDASD in raw mode.
Date: Fri, 28 Aug 2015 13:39:32 +0000 (UTC)
Message-ID: <loom.20150828T153835-853@post.gmane.org>
References: <1439995626-16202-1-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49805 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041AbbH1Njw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Aug 2015 09:39:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1ZVJsh-0003cf-Tj
	for linux-scsi@vger.kernel.org; Fri, 28 Aug 2015 15:39:48 +0200
Received: from cpe-70-113-27-207.austin.res.rr.com ([70.113.27.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2015 15:39:47 +0200
Received: from wenxiong by cpe-70-113-27-207.austin.res.rr.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2015 15:39:47 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Gabriel Krisman Bertazi <krisman <at> linux.vnet.ibm.com> writes:

> 
> Disable underlength error verification based on count of bytes actually
> transferred for AF DASD devices when SIS pipe mode is enabled.
> 
> This avoids unexpected underlength errors when issuing some commands in
> raw mode.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman <at> linux.vnet.ibm.com>

Reviewed-by: Wen Xiong<wenxiong@linux.vnet.ibm.com>

