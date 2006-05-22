From: Amit Arora <aarora@in.ibm.com>
Subject: Re: [PATCH] scsi: Return -EINVAL when "id == max_id" in
	scsi_scan_host_selected()
Date: Mon, 22 May 2006 12:01:39 -0700
Message-ID: <1148324498.24379.13.camel@amitarora.in.ibm.com>
References: <20060521033428.61699.qmail@web31813.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50095 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750868AbWEVTC3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 May 2006 15:02:29 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k4MJ2QYG016609
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 15:02:26 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k4MJ2QmQ075862
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 15:02:26 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k4MJ2P6I008556
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 15:02:26 -0400
In-Reply-To: <20060521033428.61699.qmail@web31813.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, patmans@us.ibm.com

On Sat, 2006-05-20 at 20:34, Luben Tuikov wrote:
> Hi Amit,
> 
> Welcome to the club!
> 
> You'll find a lot more other "bugs" in the Linux SCSI Core.  Not much
> has changed in the past 6 years, nothing in the core at least.
> 
> As to your particular gripe: you're right.  But I doubt anything would
> get fixed or changed any time soon.  There is very little competence
> which also has power to change things in the SCSI part of the Linux.
> Take a look at the SCSI mailing list archives for good ol' laughs.
> 
> People here think that the concept of a "host" should be escalated to
> the block subsystem, people here think that "REQUEST SENSE" clears ACA,
> and that calling done() and then turning around to do eh on the
> command in question is ok.  People here think that using link
> commands has something to do with barriers and atomic transactions.
> "SCSI device with Target ports" is called "techno-gibberish" here.
> 
> Anyway, I'd suggest fixing such things in your own version/git tree
> of the kernel.
> 
> As to naming: I always call such things "num_of_xyz" to be absolutely
> clear that the enumeration is "0 <= index_xyz < num_of_xyz".
> 
> Good luck,
>     Luben 

Hi Luben,

Thanks for replying!

I understand the competency part - but then, there are experts like you
who can surely fix such problems. :)
I would appreciate if you can come up with an acceptable patch for this.

Thanks again!
Regards,
Amit Arora



