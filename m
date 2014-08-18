From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/3] scsi_debug: give unit attention and other errors precedence over TSF
Date: Mon, 18 Aug 2014 08:37:12 -0400
Message-ID: <yq1k366x9c7.fsf@sermon.lab.mkp.net>
References: <53E0AFFE.6080202@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46309 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaHRMhW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Aug 2014 08:37:22 -0400
In-Reply-To: <53E0AFFE.6080202@interlog.com> (Douglas Gilbert's message of
	"Tue, 05 Aug 2014 12:20:46 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Elliott, Robert (Server Storage)" <elliott@hp.com>

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> Give existing errors priority over the generation of Task Set Full
Doug> (TSF) errors. So that max_queue is not exceeded, existing errors
Doug> may be sent back in the invocation thread.  This is done so errors
Doug> like Unit Attentions are not hidden and lost by either max_queue
Doug> exceeded or real/injected TSFs.

Doug> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
