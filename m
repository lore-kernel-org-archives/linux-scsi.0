From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH 1/10] mptfusion : Transport Layer Retry support
Date: Wed, 12 Jul 2006 13:40:08 -0400
Message-ID: <1152726008.4086.7.camel@mulgrave.il.steeleye.com>
References: <20060712170507.GA10308@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:32676 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932162AbWGLRkL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jul 2006 13:40:11 -0400
In-Reply-To: <20060712170507.GA10308@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, dougg@torque.net

On Wed, 2006-07-12 at 11:05 -0600, Eric Moore wrote:
> Response from co-worker that implemented this:

> The reason HP switched from using a standard Mode Page setting to
> using a vendor unique CDB is due to SCSI protocol problems.

I haven't objected to the vendor specific CDB yet ... although if
everyone implemented one of these the first time they found a difficulty
with one of the SCSI standards, the storage world would be in a bit of a
mess.

What I did say is that you can't do this in the driver ... it has to be
in the transport layer because it's not a driver problem.  Any other SAS
driver would have the same issue.

> The usage of Mode Sense and Mode Select will still work with the HP
> tape drives, if you can find a way around the above issues.  But I
> would suggest discussing any solution with the HP-Bristol tape drive
> folks.

Yes ... someone at HP is asking them about this ...

James


