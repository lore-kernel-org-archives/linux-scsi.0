From: James.Smart@Emulex.Com
Subject: RE: [RFC] adding per scsi-host workqueues for defered processing
Date: Mon, 21 Feb 2005 23:08:07 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C12EC03@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from emulex.emulex.com ([138.239.112.1]:33487 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S262200AbVBVEI2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 23:08:28 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

> > 
> > I'd like to propose the addition of a per-Scsi_Host work-queue to
> > manage these scanning as well as any other (relevant)
> > lower-level-driver differed requests.
> 
> Why not use the per-host error handler thread for this?

brings a deadlock condition to mind - where the error thread is needed
in order to cancel/terminate an i/o issued via the scan.

-- james s
