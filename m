From: Mark Lord <liml@rtr.ca>
Subject: Re: Process Scheduling Issue using sg/libata
Date: Fri, 16 Nov 2007 23:30:26 -0500
Message-ID: <473E6E62.9090309@rtr.ca>
References: <8202f4270711161649v75d06d35kd1d56e36d272a883@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:1592 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371AbXKQEa2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Nov 2007 23:30:28 -0500
In-Reply-To: <8202f4270711161649v75d06d35kd1d56e36d272a883@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fajun Chen <fajunchen@gmail.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org, Tejun Heo <htejun@gmail.com>

Fajun Chen wrote:
> Hi All,
> 
> I use sg/libata and ata pass through for read/writes. Linux 2.6.18-rc2
> and libata version 2.00 are loaded on ARM XScale board.  Under heavy
> cpu load (e.g. when blocks per transfer/sector count is set to 1),
> I've observed that the test application can suck cpu away for long
> time (more than 20 seconds) and other processes including high
> priority shell can not get the time slice to run.  What's interesting
> is that if the application is under heavy IO load (e.g. when blocks
> per transfer/sector count is set to 256),  the problem goes away. I
> also tested with open source code sg_utils and got the same result, so
> this is not a problem specific to my user-space application.
..

Post the relevant code here, and then we'll be able to better understand
and explain it to you.

For example, if the code is using ATA opcodes 0x20, 0x21, 0x24,
0x30, 0x31, 0x34, 0x29, 0x39, 0xc4 or 0xc5 (any of the R/W PIO ops),
then this behaviour does not surprise me in the least.  Fully expected
and difficult to avoid.

Cheers

