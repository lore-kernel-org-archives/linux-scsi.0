From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [scsi 5/7 RESEND] scsi_debug: schedule_resp fix input variable check
Date: Thu, 30 Jul 2015 13:23:32 -0400
Message-ID: <yq11tfpo8yz.fsf@sermon.lab.mkp.net>
References: <1438091666-18113-1-git-send-email-tomas.winkler@intel.com>
	<1438091666-18113-5-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32844 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbbG3RXl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2015 13:23:41 -0400
In-Reply-To: <1438091666-18113-5-git-send-email-tomas.winkler@intel.com>
	(Tomas Winkler's message of "Tue, 28 Jul 2015 16:54:24 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>

>>>>> "Tomas" == Tomas Winkler <tomas.winkler@intel.com> writes:

Tomas> The function should never be called with cmnd NULL so put a fat
Tomas> WARN there.  Fix also smatch wraning: schedule_resp() warn:
Tomas> variable dereferenced before check 'cmnd'

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
