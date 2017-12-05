From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_devinfo: cleanly zero-pad devinfo strings
Date: Mon, 04 Dec 2017 22:09:06 -0500
Message-ID: <yq17eu16fcd.fsf@oracle.com>
References: <20171127224735.32139-1-mwilck@suse.com>
        <20171127224735.32139-2-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37478 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751852AbdLEDJf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2017 22:09:35 -0500
In-Reply-To: <20171127224735.32139-2-mwilck@suse.com> (Martin Wilck's message
        of "Mon, 27 Nov 2017 23:47:35 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Alan Stern <stern@rowland.harvard.edu>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, Martin Wilck <mwilck@suse.de>


Martin,

> Cleanly fill memory for "vendor" and "model" with 0-bytes for the
> "compatible" case rather than adding only a single 0 byte.  This
> simplifies the devinfo code a a bit, and avoids mistakes in other
> places of the code (not in current upstream, but we had one such
> mistake in the SUSE kernel).

Applied to 4.15/scsi-fixes. Thank you!

-- 
Martin K. Petersen	Oracle Linux Engineering
