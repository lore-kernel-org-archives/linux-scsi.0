From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SYM8xx_2 driver ignores certain EEPROM settings
Date: Fri, 31 Dec 2004 09:01:35 -0600
Message-ID: <1104505295.5247.2.camel@mulgrave>
References: <200412311343.42484.peter.missel@onlinehome.de>
	 <20041231145306.GB18080@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:35476 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262112AbULaPBx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Dec 2004 10:01:53 -0500
In-Reply-To: <20041231145306.GB18080@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Peter Missel <peter.missel@onlinehome.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2004-12-31 at 14:53 +0000, Matthew Wilcox wrote:
> I don't need you to do that -- I know the ability has been removed from the
> driver.  I bet I can put it back without disturbing things too much.

There are two ways of doing this:

1) one would be to have the hard coded limits in the sym2 driver (like
they were previously) and make sure we don't allow setting or
negotiating over them or

2) have the limits stored in the SPI transport class and make it enforce
them.

1) Is probably easier (less code since you just put back a modification
of what was taken out) 2) would be more globally useful, though ...

James


