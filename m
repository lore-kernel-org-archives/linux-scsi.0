From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Problem Adding Transport Class support to fusion
Date: Mon, 30 May 2005 16:55:52 -0500
Message-ID: <1117490152.4913.20.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:5344 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261777AbVE3Vz7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 May 2005 17:55:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

I thought I'd look into this, since it seems to be relatively simple:
you get the parameters from the device config page0 and set them via
device config page1 as I read the driver.

However, this appears to be where my fusion card runs into difficulty.
Debugging the header setup I get this:

mptbase: ioc1: Headers: 0: version 0 length 0
mptbase: ioc1: Headers: 1: version 3 length 4

The driver seems to think this is valid, but if it occurs, there's no
way to get the parameters or run domain validation.  Is this correct?
There are classes of fusion card for which we simply cannot obtain
transport data? 

Or is there a work around that's not coded into the driver?

James


