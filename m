From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Fix off-by-one LUN check in scsi_scan_host_selected()
Date: Fri, 17 Oct 2014 19:30:56 -0400
Message-ID: <yq1r3y62s0f.fsf@sermon.lab.mkp.net>
References: <20141009123948.ed14b2f96456fecdb4af960b@clara.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29507 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaJQXbF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Oct 2014 19:31:05 -0400
In-Reply-To: <20141009123948.ed14b2f96456fecdb4af960b@clara.co.uk> (Mark
	Knibbs's message of "Thu, 9 Oct 2014 12:39:48 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Knibbs <markk@clara.co.uk>
Cc: linux-scsi@vger.kernel.org

>>>>> "Mark" == Mark Knibbs <markk@clara.co.uk> writes:

Mark> Hi, The Scsi_Host structure max_lun field is the maximum allowed
Mark> LUN plus 1. So a LUN value is invalid if >= max_lun.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
