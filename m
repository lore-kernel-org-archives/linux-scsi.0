From: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>
Subject: Re: SYM8xx_2 driver ignores certain EEPROM settings
Date: Sat, 01 Jan 2005 23:16:43 +0100
Message-ID: <m3pt0okd6c.fsf@merlin.emma.line.org>
References: <200412311343.42484.peter.missel@onlinehome.de>
	<20041231145306.GB18080@parcelfarce.linux.theplanet.co.uk>
	<200412311620.44488.peter.missel@onlinehome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dt.E-Technik.Uni-Dortmund.DE ([129.217.163.1]:38291 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S261184AbVAAWQq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Jan 2005 17:16:46 -0500
In-Reply-To: <200412311620.44488.peter.missel@onlinehome.de> (Peter Missel's
	message of "Fri, 31 Dec 2004 16:20:44 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Missel <peter.missel@onlinehome.de>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

Peter Missel <peter.missel@onlinehome.de> writes:

> I'm fine with the additional safety from the Domain Validation. Nonetheless, 
> the driver shouldn't validate speeds and/or transfer widths that have been 
> forbidden by the user.
> Another example (which I can't verify right now) is negotiation width. 
> External HDD enclosures might be connected through a Narrow cable but 
> actually contain a Wide drive. That'll be one thing where the user would use 
> the SCSI BIOS to limit the particular unit to Narrow. This however would 
> possibly be caught by the DM failing.

No external enclosure necessary. There are also wide chips with only
narrow connectors, for instance, on the Tekram DC-310U, DC-390U boards -
they use a SYM53C860 or SYM53C875, a wide capable chip, but provide only
narrow (50-pin) connectors. I last tried some 2.4.X kernel on such a
setup, and haven't used the DC-390U in a long time (I replaced it by a
DC-390F) - so I cannot test at this time.

-- 
Matthias Andree
