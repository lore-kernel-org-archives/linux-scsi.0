From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: question scsi_register verses register_blkdev
Date: Fri, 20 Oct 2006 23:03:59 +0200
Message-ID: <453939BF.8070506@s5r6.in-berlin.de>
References: <861B5CF71BC70C478DFEB9EAFE98F699ACA42C@G3W0068.americas.hpqcorp.net> <20061020172549.7666.qmail@web31812.mail.mud.yahoo.com> <4538C032.8E7F.00B8.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:17855 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1946502AbWJTVEE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:04:04 -0400
In-Reply-To: <4538C032.8E7F.00B8.0@novell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thayne Harmon <THARMON@novell.com>
Cc: linux-scsi@vger.kernel.org

Thayne Harmon wrote:
> I am trying to write a linux driver (I'm new at this) for a
> standard SCSI host bus adapter.
...

Seems you want to write a SCSI low-level provider. The low-level API is
documented in linux/Documentation/scsi_mid_low_api.txt.
-- 
Stefan Richter
-=====-=-==- =-=- =-=--
http://arcgraph.de/sr/
