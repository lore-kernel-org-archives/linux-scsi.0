From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: SYM8xx_2 driver ignores certain EEPROM settings
Date: Sun, 2 Jan 2005 01:40:04 +0100
Message-ID: <20050102004004.GA25446@merlin.emma.line.org>
References: <200412311343.42484.peter.missel@onlinehome.de> <200412311620.44488.peter.missel@onlinehome.de> <m3pt0okd6c.fsf@merlin.emma.line.org> <200501020128.32217.peter.missel@onlinehome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from krusty.dt.E-Technik.Uni-Dortmund.DE ([129.217.163.1]:37268 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S261203AbVABAkL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Jan 2005 19:40:11 -0500
Content-Disposition: inline
In-Reply-To: <200501020128.32217.peter.missel@onlinehome.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Missel <peter.missel@onlinehome.de>
Cc: Matthias Andree <ma@dt.e-technik.uni-dortmund.de>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

Peter Missel schrieb am 2005-01-02:

> This possibly is because with the exception of the 815 chip, LSI's Narrow 
> chips don't have a BIOS ROM interface, while the Wide chips do. So if you 
> were to build a controller card w/ boot ROM support, you had to use a Wide 
> chip even if the card was to be Narrow-only.
> 
> Tekram's 310U, IIRC, was a ROM-less card that used the 860 Narrow
> chip, wasn't it?

On the DC-310U, they used a SYM53C860, I'm not sure about the specs of
the chip now that you write narrow.

-- 
Matthias Andree
