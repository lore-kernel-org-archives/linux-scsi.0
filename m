From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: AcornSCSI patches
Date: Mon, 02 Jun 2008 11:43:35 -0500
Message-ID: <1212425015.3369.16.camel@localhost.localdomain>
References: <20080512170914.GB25110@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54818 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752973AbYFBQnl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2008 12:43:41 -0400
In-Reply-To: <20080512170914.GB25110@flint.arm.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LAK <linux-arm-kernel@lists.arm.linux.org.uk>

On Mon, 2008-05-12 at 18:09 +0100, Russell King wrote:
> Here follows a series of five patches to bring the Acorn SCSI driver
> back up to date.  Part of the purpose of these patches is to remove
> some of the remaining cruft in the ARM RiscPC platform support code,
> namely the old style of expansion cards using the PCI/ISA IO accessors
> rather than iomem accessors.
> 
> The series also converts the driver to use the 'newer' error recovery
> methods, which was the reason the driver was originally marked broken.
> 
> These patches are only compile tested; since it's been marked broken
> for so long, getting it in a buildable state again is a worthwhile
> first step.
> 
> Could you ack the patches; I'll add relevant acks to the version in
> my git tree.  My intention is to push this during the next merge
> window.  Thanks.

Looks fine to me.  I note it seems to be dependent on several pieces in
the current arm tree, so you can add my ack and take it through your
tree to preserve the dependencies.

Thanks,

James



