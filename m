From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented and there's not way to prevent the kernel from using the 2nd cdb byte for the LUN
Date: Fri, 22 Aug 2014 11:08:12 -0400
Message-ID: <yq1egw8pnoj.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.44L0.1408221044450.967-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40053 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbaHVPIv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Aug 2014 11:08:51 -0400
In-Reply-To: <Pine.LNX.4.44L0.1408221044450.967-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Fri, 22 Aug 2014 10:53:42 -0400 (EDT)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>, Tiziano Bacocco <tiziano.bacocco@gmail.com>, bugzilla-daemon@bugzilla.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

>>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:

Alan> Sending the initial INQUIRY command to LUNs larger than 0 involves
Alan> a chicken-and-egg problem -- we don't know whether to fill in the
Alan> LUN bits in the command until we know the SCSI level, and we don't
Alan> know the SCSI level until the INQUIRY response is received.  The
Alan> solution we have been using is to store the most recently
Alan> discovered level in the target structure, and use it as a default.
Alan> If probing starts with LUN 0, and if all the LUNs have similar
Alan> levels, this ought to work.

Looks good, Alan.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
