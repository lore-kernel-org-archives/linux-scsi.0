From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/3] scsi_debug: scsi_cmnd->cmnd check and casts unnecessary
Date: Mon, 18 Aug 2014 08:37:28 -0400
Message-ID: <yq1fvgux9br.fsf@sermon.lab.mkp.net>
References: <53E0AFD2.3050202@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46419 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbaHRMhf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Aug 2014 08:37:35 -0400
In-Reply-To: <53E0AFD2.3050202@interlog.com> (Douglas Gilbert's message of
	"Tue, 05 Aug 2014 12:20:02 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Dan Carpenter <dan.carpenter@oracle.com>

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> This patch removes a NULL check for the scsi_cmnd::cmnd pointer
Doug> since many other instances in this driver and elsewhere assume it
Doug> is valid. Also redundant casts to 'unsigned char *' are removed as
Doug> the pointer has that type.

Doug> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
