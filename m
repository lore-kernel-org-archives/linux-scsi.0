From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH] CDC_WR
Date: 11 Nov 2003 15:24:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068589440.5909.33.camel@patrh9>
References: <1068479926.2313.7.camel@patrh9>
	 <1068485442.4495.25.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:47759 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263770AbTKKWYa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2003 17:24:30 -0500
Received: from royntex01.iomegacorp.com (unknown [147.178.90.120])
	by email.iomega.com (Postfix) with ESMTP id F0D8F24D6
	for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2003 15:24:29 -0700 (MST)
In-Reply-To: <1068485442.4495.25.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

> Slanderous or not, also I hear:

6) We may have good precedent for our idea of (a) fetch header, (b)
interpret additional length, then (c) fetch all available op x46 Get
Configuration data.

Specifically we have one sample of Windows XP SP1 starting life after
plug in with that politically correct speech:

http://marc.theaimsgroup.com/?l=linux-scsi&m=106858800007411

List: linux-scsi
Subject: Re: usb storage traces
Date: 2003-11-11 21:59:22

7) Fetching all the device configuration this way lets us see the
"profile list".  Testing whetrher the profile list contains one or more
writable profiles, none of which are DVD+RW, might be our best mmc way
of guessing if open of device should fail via EROFS or no.

Pat LaVarre


