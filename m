From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] remove scsi_cmnd.eh_state
Date: Mon, 20 Jun 2005 08:28:50 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458B01520CD8@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:6350 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261229AbVFTM3g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 08:29:36 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

If the code is not in place, then array devices will go offline.

The array needs to have a 5 minute timeout, all other devices can
timeout as per the SCSI subsystem.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Christoph Hellwig [mailto:hch@lst.de] 
Sent: Monday, June 20, 2005 8:28 AM
To: Salyzyn, Mark
Cc: Christoph Hellwig; jejb@steeleye.com; linux-scsi@vger.kernel.org
Subject: Re: [PATCH] remove scsi_cmnd.eh_state

On Mon, Jun 20, 2005 at 08:26:24AM -0400, Salyzyn, Mark wrote:
> A bugfix was submitted a couple of weeks ago for the code affected by
> Christoph's patch. I suggest the following modification to merge the
two
> patches:

No, it's not a bugfix.  Any access of a driver to eh_timeout is a bug.

