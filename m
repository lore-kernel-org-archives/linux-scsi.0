From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH RFC 0/2] imu-scsi for iop13xx
Date: Thu, 25 Jan 2007 16:15:05 -0500
Message-ID: <1169759705.3037.76.camel@mulgrave.il.steeleye.com>
References: <20070124182245.6029.43097.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56336 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030573AbXAYVPk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jan 2007 16:15:40 -0500
In-Reply-To: <20070124182245.6029.43097.stgit@dwillia2-linux.ch.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dan.j.williams@intel.com
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.arm.linux.org.uk, linux-scsi@vger.kernel.org, greg.b.tucker@intel.com

On Wed, 2007-01-24 at 11:22 -0700, dan.j.williams@intel.com wrote:
> The imu (inter-processor messaging unit) on the iop13xx enables mailbox
> style communication between the two cores on iop13xx.  Greg Tucker has
> has wrapped this capability in a scsi driver which allows Linux to
> interface with the other core as if it were a scsi disk target.  I would
> like to submit it for 2.6.21 consideration.  As it is an
> ARM-platform-specific driver does it fall under Russell's purview, or
> James' since it is a scsi driver.

Both of ours, I'm afraid ... as in Russell is the sign off for the arm
pieces and I'll do the SCSI bits.

As to logistics, we could do it split tree, or we could do cross
signoffs for either the SCSI or the ARM tree.

James


