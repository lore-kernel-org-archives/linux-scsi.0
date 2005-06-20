From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] remove scsi_cmnd.eh_state
Date: Mon, 20 Jun 2005 08:42:33 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B01520CF2@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:65234 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261240AbVFTMnS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 08:43:18 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

Ok, let your patch through, within the week I will have a corresponding
patch for the device timeouts ...

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Christoph Hellwig [mailto:hch@lst.de] 
Sent: Monday, June 20, 2005 8:35 AM
To: Salyzyn, Mark
Cc: Christoph Hellwig; jejb@steeleye.com; linux-scsi@vger.kernel.org
Subject: Re: [PATCH] remove scsi_cmnd.eh_state

On Mon, Jun 20, 2005 at 08:28:50AM -0400, Salyzyn, Mark wrote:
> If the code is not in place, then array devices will go offline.
> 
> The array needs to have a 5 minute timeout, all other devices can
> timeout as per the SCSI subsystem.

The proper API to do that is to set scsi_device.timeout in
->slave_configure.

