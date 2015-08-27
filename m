From: Wendy Xiong <wenxiong@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] ipr: Enable SIS pipe commands for SIS-32 devices.
Date: Thu, 27 Aug 2015 19:28:26 +0000 (UTC)
Message-ID: <loom.20150827T212605-424@post.gmane.org>
References: <1439995626-16202-1-git-send-email-krisman@linux.vnet.ibm.com> <1439995626-16202-2-git-send-email-krisman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56413 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186AbbH0TfQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Aug 2015 15:35:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <lnx-linux-scsi@m.gmane.org>)
	id 1ZV2wy-0003ff-QU
	for linux-scsi@vger.kernel.org; Thu, 27 Aug 2015 21:35:05 +0200
Received: from 32.97.110.60 ([32.97.110.60])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2015 21:35:04 +0200
Received: from wenxiong by 32.97.110.60 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2015 21:35:04 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Gabriel Krisman Bertazi <krisman <at> linux.vnet.ibm.com> writes:

> 
> Remove unnecessary check that disabled SIS pipe commands for SIS-32
> devices.  This change was sufficient to enable raw mode and send SIS
> pipe commands for a 57B3 device.
> 

Reviewed-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>

Thanks,

Wendy


