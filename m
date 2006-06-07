From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 0/6] libata: Support SATA attached via SAS
Date: Wed, 07 Jun 2006 13:09:34 -0400
Message-ID: <4487084E.7090307@torque.net>
References: <4486FDBD.9030200@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40641 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932348AbWFGRJu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jun 2006 13:09:50 -0400
In-Reply-To: <4486FDBD.9030200@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: jgarzik@pobox.com, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, 'SCSI Mailing List' <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

Brian King wrote:
> Jeff,
> 
> Here is a refresh of my patchset to allow SAS HBAs to use libata to
> control attached SATA devices. It should apply cleanly to #upstream.
> 
> James,
> 
> After our discussion at the storage summit I think I have
> a better idea what you are looking for with a SATA transport class.
> Unfortunately, the problem I am facing is that I am dealing with a
> firmware stack (ipr) which does not expose the physical transport
> to the host. The ipr firmware does all the device discovery and reports
> a configuration table describing the attached devices, but does not
> export any physical topology information. At some point in the future
> I hope to be able to extract this information from the ipr firmware
> stack and convert ipr to be able to utilize the sas/sata transport class,
> but, unfortunately, the firmware interfaces to accomplish this
> aren't available at this time.

Brian,
Does that mean that it doesn't have an SMP pass through?
SMP and the SAS addresses attached to the phys on the HBA
is enough to do discovery in the user space.

Doug Gilbert


