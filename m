From: john clyne <clyne@ucar.edu>
Subject: IO transfer limits
Date: Wed, 10 Jan 2007 08:16:24 -0800 (PST)
Message-ID: <8260533.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.nabble.com ([72.21.53.35]:58051 "EHLO talk.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964944AbXAJQkD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jan 2007 11:40:03 -0500
Received: from [72.21.53.38] (helo=jubjub.nabble.com)
	by talk.nabble.com with esmtp (Exim 4.50)
	id 1H4g7k-0006fX-9I
	for linux-scsi@vger.kernel.org; Wed, 10 Jan 2007 08:16:24 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Can anyone give me some guidance on where in the IO stack I might be running
into a 512KB limit on IO transfer sizes to an external FC device? I've
checked IO scheduler parameter
(/sys/block/<dev>/queue/{max_sectors_kb,max_hw_sectors_kb}. Both are set to
32767. I'm using Qlogic HBAs (qla2312), but I don't see any relevent
parameters. I'm running RHEL 4.0 with a 2.6.9-34 kernel. Any pointers would
be greatly appreciated.

cheers - jc

-- 
View this message in context: http://www.nabble.com/IO-transfer-limits-tf2953389.html#a8260533
Sent from the linux-scsi mailing list archive at Nabble.com.

