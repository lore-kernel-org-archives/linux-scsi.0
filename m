From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [Patch]Status_byte() in drivers/scsi/scsi.h
Date: Fri, 20 Jun 2003 10:39:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030620143925.GA29553@gtf.org>
References: <3EF178AC.CEC2C720@in.ibm.com> <3EF17DFC.8030700@torque.net> <3EF2C869.F794F1A6@in.ibm.com> <1056112633.1804.5.camel@mulgrave> <3EF311A7.8030102@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-64-213-145-173.atlantasolutions.com ([64.213.145.173]:24512
	"EHLO havoc.gtf.org") by vger.kernel.org with ESMTP id S262321AbTFTOZY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2003 10:25:24 -0400
Content-Disposition: inline
In-Reply-To: <3EF311A7.8030102@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Sachin Sant <sachinp@in.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Jun 20, 2003 at 11:52:39PM +1000, Douglas Gilbert wrote:
> On a related subject, SPC-3 defines a new "descriptor" sense
> data format (see section 4.5). It is a lot cleaner and more
> compact than the original one and is controlled by the D_SENSE
> bit in the control mode page. Has anybody seen a target
> that supports these?

If it's in the spec, I'm sure I could create one... <evil grin>

	Jeff



