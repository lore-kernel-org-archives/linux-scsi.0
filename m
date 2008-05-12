From: Russell King <rmk@arm.linux.org.uk>
Subject: AcornSCSI patches
Date: Mon, 12 May 2008 18:09:15 +0100
Message-ID: <20080512170914.GB25110@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37142 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbYELRJZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 May 2008 13:09:25 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LAK <linux-arm-kernel@lists.arm.linux.org.uk>

James,

Here follows a series of five patches to bring the Acorn SCSI driver
back up to date.  Part of the purpose of these patches is to remove
some of the remaining cruft in the ARM RiscPC platform support code,
namely the old style of expansion cards using the PCI/ISA IO accessors
rather than iomem accessors.

The series also converts the driver to use the 'newer' error recovery
methods, which was the reason the driver was originally marked broken.

These patches are only compile tested; since it's been marked broken
for so long, getting it in a buildable state again is a worthwhile
first step.

Could you ack the patches; I'll add relevant acks to the version in
my git tree.  My intention is to push this during the next merge
window.  Thanks.

-- 
Russell King
