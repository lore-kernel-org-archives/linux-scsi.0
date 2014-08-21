From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented and there's not way to prevent the kernel from using the 2nd cdb byte for the LUN
Date: Thu, 21 Aug 2014 17:43:41 -0400
Message-ID: <yq1bnrdr01e.fsf@sermon.lab.mkp.net>
References: <Pine.LNX.4.44L0.1408211326070.918-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19644 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbaHUVoY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Aug 2014 17:44:24 -0400
In-Reply-To: <Pine.LNX.4.44L0.1408211326070.918-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Thu, 21 Aug 2014 13:31:34 -0400 (EDT)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Douglas Gilbert <dgilbert@interlog.com>, Tiziano Bacocco <tiziano.bacocco@gmail.com>, bugzilla-daemon@bugzilla.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

>>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:

Alan> Okay, here's a patch that implements the suggestion, except that I
Alan> put the flag in the Scsi_Host structure instead of the template.
Alan> This was to minimize the impact of the change.  Among the various
Alan> SCSI-over-USB transports, only the Bulk-Only transport gives the
Alan> LUN separately from the CDB.  I don't know if there are any
Alan> multi-LUN USB devices that don't use the Bulk-Only transport, but
Alan> if there are then they won't work if the LUN isn't stored in
Alan> CDB[1].

I'm in agreement with this approach.

-- 
Martin K. Petersen	Oracle Linux Engineering
