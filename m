From: Mark Hounschell <markh@compro.net>
Subject: Scsi tape write protect status question
Date: Tue, 14 Jul 2009 17:03:42 -0400
Message-ID: <4A5CF2AE.2020001@compro.net>
Reply-To: markh@compro.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.compro.net ([216.54.166.4]:11775 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196AbZGNVSb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jul 2009 17:18:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mark Hounschell <dmarkh@cfl.rr.com>

Sorry to bother you all with such an easy thing. I can't figure out how the
kernel knows I have a write protected tape in a drive that I open via

open("/dev/st0", O_RDWR, cf_flg, 0666)

Using the sgio interface I can only sense a write protect status after
attempting to to a write.
How can one know this before doing a write op?

Thanks in advance
Mark
