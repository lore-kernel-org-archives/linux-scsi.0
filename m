From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: [RFC PATCH 2.6.9-rc2] Add sysfs queue depth override to qla2xxx
Date: Tue, 28 Sep 2004 09:54:41 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0DD0504@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch01.qlogic.com ([198.70.193.200]:60048 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S267993AbUI1Qyx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Sep 2004 12:54:53 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jeremy Higdon <jeremy@sgi.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tuesday, September 28, 2004 7:06 AM, James Bottomley wrote:
> On Tue, 2004-09-28 at 03:54, Jeremy Higdon wrote:
> > 
> > Found a bug in the patch.  It returned an incorrect count if
> > tagged_supported was not true.
> 
> I haven't had time to check yet, but I believe I remember queue depth
> being also a parameter that has to be communicated to the card's
> firmware for the sizing of an internal queue.

Not needed for the fibre-channel driver.  The only rate-limiter is the
size of the host request-queue.

--
Andrew
