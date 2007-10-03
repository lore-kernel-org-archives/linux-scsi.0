From: David Miller <davem@davemloft.net>
Subject: Re: generating a Linux WWN?
Date: Wed, 03 Oct 2007 15:17:29 -0700 (PDT)
Message-ID: <20071003.151729.95504687.davem@davemloft.net>
References: <4703FAB0.10702@garzik.org>
	<344765.55522.qm@web31815.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42899
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752116AbXJCWRa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2007 18:17:30 -0400
In-Reply-To: <344765.55522.qm@web31815.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: jeff@garzik.org, lydianconcepts@gmail.com, mdr@sgi.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

From: Luben Tuikov <ltuikov@yahoo.com>
Date: Wed, 3 Oct 2007 15:08:48 -0700 (PDT)

> Your "want to get their card working" way of view is very
> simplistic to justify generating and assigning SAS WWN in the kernel.
> This is the job of the manufacturer/packager, not the host OS.

When you are thousands of miles away from the data center and lose all
of your storage and therefore can't boot correctly because the WWN
info is corrupted, you won't have this unbelievably fascist attitude
about this problem.

Give people an _OPTION_!

This is about as anti-social as when the Intel folks refused to
themselves put in a driver option to try to use an eepro100 card even
if the EEPROM was corrupted and had a bad checksum.

For the person who hits this, it's a big issue to have a way to still
try to bring things up.

If you don't provide this, you want people to suffer more than
necessary when something goes wrong, and that by definition makes you
an asshole.
