From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] CDC_WR
Date: 13 Nov 2003 15:35:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068762936.2851.50.camel@patrh9>
References: <1068479926.2313.7.camel@patrh9>
	 <1068485442.4495.25.camel@patrh9>  <1068589440.5909.33.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:60383 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264445AbTKMWgL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 17:36:11 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id 8BEFA2965
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2003 15:36:08 -0700 (MST)
In-Reply-To: <1068589440.5909.33.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Calling all MMC gurus ...

> > Slanderous or not, also I hear:
> ...
> 7) Fetching all the device configuration this way lets us see the
> "profile list".  Testing whetrher the profile list contains one or more
> writable profiles, none of which are DVD+RW, might be our best mmc way
> of guessing if open of device should fail via EROFS or no.

Ouch, not so good.

The DVD-ROM drive in my cube reports profiles 0010 000A 0009 0008 0002 =
DVD-ROM, CD-RW, CD-R, CD-ROM, Removable Disk.

I think next I will try saying the current-or-not presence of any
non-standard profile, or of any MMC profile that does not require
feature x0020 Random Writable, implies not-writable, but the
current-or-not presence of feature x0020 Random Wruitable implies
yes-writable.

Pat LaVarre


