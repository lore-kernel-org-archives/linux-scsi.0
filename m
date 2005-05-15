From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: 53C8XX /sys/devices/pci*/*/config revisited
Date: Sun, 15 May 2005 13:26:55 +0200
Message-ID: <1116156415.6270.19.camel@laptopd505.fenrus.org>
References: <m3br7c4ur6.fsf@merlin.emma.line.org>
	 <1116155603.6270.16.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:38034 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262768AbVEOL1D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 May 2005 07:27:03 -0400
In-Reply-To: <1116155603.6270.16.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <matthias.andree@gmx.de>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>, gregkh@kroah.com


> if hal reads more than 64 bytes of config space (heck if it reads config
> space at all) then it's terminally broken.

this brings up a bug in the kernel though....
the config file is user readable! That's just plain dangerous and imo it
should be a root-only file as a result.


