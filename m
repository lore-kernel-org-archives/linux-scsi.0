From: Matthias Andree <matthias.andree@gmx.de>
Subject: Re: What is SCSI command 0xa0 ?
Date: Mon, 14 Feb 2005 22:27:46 +0100
Message-ID: <m3r7ji7rxp.fsf@merlin.emma.line.org>
References: <Pine.LNX.4.44L0.0502141558290.1175-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from krusty.dt.e-technik.Uni-Dortmund.DE ([129.217.163.1]:59558 "EHLO
	mail.dt.e-technik.uni-dortmund.de") by vger.kernel.org with ESMTP
	id S261511AbVBNV16 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2005 16:27:58 -0500
In-Reply-To: <Pine.LNX.4.44L0.0502141558290.1175-100000@ida.rowland.org> (Alan
	Stern's message of "Mon, 14 Feb 2005 16:07:05 -0500 (EST)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Samuel Colin <Samuel.Colin3@wanadoo.fr>

Alan Stern <stern@rowland.harvard.edu> writes:

> Can anybody tell me what this CDB is supposed to do, when issued to a 
> direct-access device (a disk drive)?
>
> 	a0 00 00 00 00 00 00 00 10 00 00 00
>
> It's crashing the firmware on Samuel's disk and generally causing 
> problems.  The command gets sent right after the partition table is 
> read.

"REPORT LUNS". This is probably only useful on media changers and
perhaps disk arrays.

-- 
Matthias Andree
