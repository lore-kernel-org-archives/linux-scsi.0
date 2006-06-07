From: Jeff Garzik <jeff@garzik.org>
Subject: Re: ATA Pass-Through support
Date: Wed, 7 Jun 2006 14:26:19 -0400
Message-ID: <20060607182619.GC21726@havoc.gtf.org>
References: <DF9C50EF9E8CDA45A06FE8735C68F85EEB6319@earthex2.power.com> <44871954.8060701@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:40082 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751215AbWFGS0V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jun 2006 14:26:21 -0400
Content-Disposition: inline
In-Reply-To: <44871954.8060701@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Quat Le <Quat.Le@dothill.com>, linux-scsi@vger.kernel.org

On Wed, Jun 07, 2006 at 02:22:12PM -0400, Douglas Gilbert wrote:
> My example code only assumed a SCSI pass through
> (SG_IO in this case) and a SATL ** that implements
> the ATA PASS THROUGH SCSI commands. The MPT Fusion SAS
> HBAs have their own SATL (not libata based) but unfortunately
> don't implement the ATA pass through commands. My information
> is that they will in the future. They do have a proprietary
> ATA command passthrough.

Note that there will -always- be proprietary ATA passthrough to deal
with.  'sx8' driver firmware has such, for example.

	Jeff



