From: Douglas Gilbert <dougg@torque.net>
Subject: Re: What is SCSI command 0xa0 ?
Date: Tue, 15 Feb 2005 08:02:58 +1000
Message-ID: <42112012.3000801@torque.net>
References: <Pine.LNX.4.44L0.0502141558290.1175-100000@ida.rowland.org> <m3r7ji7rxp.fsf@merlin.emma.line.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from [65.23.158.22] ([65.23.158.22]:13290 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261578AbVBNWCd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Feb 2005 17:02:33 -0500
In-Reply-To: <m3r7ji7rxp.fsf@merlin.emma.line.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <matthias.andree@gmx.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, SCSI development list <linux-scsi@vger.kernel.org>, Samuel Colin <Samuel.Colin3@wanadoo.fr>

Matthias Andree wrote:
> Alan Stern <stern@rowland.harvard.edu> writes:
> 
> 
>>Can anybody tell me what this CDB is supposed to do, when issued to a 
>>direct-access device (a disk drive)?
>>
>>	a0 00 00 00 00 00 00 00 10 00 00 00
>>
>>It's crashing the firmware on Samuel's disk and generally causing 
>>problems.  The command gets sent right after the partition table is 
>>read.
> 
> 
> "REPORT LUNS". This is probably only useful on media changers and
> perhaps disk arrays.

... and current SCSI drafts flag support for REPORT LUNS
as mandatory for _all_ device types. I suspect that some
members of t10.org would prefer support to be optional.

Doug Gilbert


