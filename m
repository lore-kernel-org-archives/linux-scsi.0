From: James.Smart@Emulex.Com
Subject: RE: [Announce] Emulex lpfcdriver v8.0.12 available
Date: Mon, 18 Oct 2004 17:34:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F220@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:15812 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S267536AbUJRVeU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Oct 2004 17:34:20 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org

> And why should userspace mess with the adapter anyway?  The 
> older drivers
> seem to work very well without that interface.  Also note 
> that due to this
> interfasce you added really horrible helper functions in the driver.

During normal operation - you are correct.

However, all maintenance is done via userspace. There's a lot more to making a supportable product than just the driver. Are you dictating a management scheme where all maintenance/troubleshooting must be done with the driver  detached/unloaded ?

I agree it's not pretty...

> If you want this in find a portable and non-broken interface 
> together with
> the qlogic, lsi and ibm people.

That is exactly the plan - this was an early prototype of what could be turned into a proposal for this effort.

-- James S
