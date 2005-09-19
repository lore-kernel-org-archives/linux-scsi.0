From: "Duane Grigsby" <duane.grigsby@qlogic.com>
Subject: RE: eh_active checks in qla2xxx error handling
Date: Mon, 19 Sep 2005 13:47:10 -0700
Message-ID: <41EBA11203419D4CA8EB4C6140D8B40102FC139F@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:58320 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S932125AbVISUrO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Sep 2005 16:47:14 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org

Yes, agreed. I believe that code was ported from 2.4 driver where the
error handler expected DID_RESET status.  

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Christoph Hellwig
Sent: Monday, September 19, 2005 1:04 PM
To: Andrew Vasquez
Cc: linux-scsi@vger.kernel.org
Subject: Re: eh_active checks in qla2xxx error handling

On Tue, Sep 06, 2005 at 02:20:28PM +0200, Christoph Hellwig wrote:
> qla2xxx is the only driver looking at eh_active, and doing the wait
> for oustanding commands only from EH thread resets but not from the
> ioctls looks rather wrong to me.  Do you remember the rational for it?

ping?
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

