From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: I request inclusion of SAS Transport Layer and AIC-94xx into
 the kernel
Date: Fri, 30 Sep 2005 20:33:32 -0400
Message-ID: <433DD95C.5050209@pobox.com>
References: <Pine.LNX.4.10.10509300015100.27623-100000@master.linux-ide.org> <433D8542.1010601@adaptec.com> <A0262C6F-6B0E-4790-BA42-FAFD6F026E0A@mac.com> <433D8D1F.1030005@adaptec.com> <0F03AA4B-D2D1-4C57-B81B-FC95CB863A98@mac.com> <433DB8AF.4090207@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:22409 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750704AbVJAAdm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Sep 2005 20:33:42 -0400
In-Reply-To: <433DB8AF.4090207@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Kyle Moffett <mrmacman_g4@mac.com>, Andre Hedrick <andre@linux-ide.org>, "David S. Miller" <davem@davemloft.net>, willy@w.ods.org, patmans@us.ibm.com, ltuikov@yahoo.com, linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Luben Tuikov wrote:
> But none of the ideas: 64 bit LUN, HCIL removal, etc.,
> were accepted with "submit a patch".

I concede this may have been the response in the past.  Its not, now.



>>So you're saying fixing the current SCSI subsystem once *now* costs  
>>more than applying all *future* SCSI fixes to _two_ SCSI subsystems,  
>>handling bug reports for _two_ SCSI subsystems, etc.
> 
> 
> I'm saying that the current "old" one is already obsolete,
> when all you have is a SAS chip on your mainboard.
> 
> All you need is a small, tiny, fast, slim SCSI Core.

Then don't use it at all.  Write a block driver, if you really feel we 
need two SCSI cores.


> Politics: "Nah, whatever you say, specs are *crap* and we'll
> do it our way.  We are not interested in your way, even if it
> were better.  Oh, and BTW, REQUEST SENSE clears ACA and LUN
> is a u64."

This is a misrepresentation.  -We- understand the stuff you have posted.

But you continue to demonstrate that you simply do not understand the 
existing SCSI core code.

The SAS transport class supports commonality across all SAS 
implementations.  This includes both MPT and Adaptec 94xx.

SAS transport class + libsas supports software implementations of SAS, 
including transport layer management.  This includes Adaptec 94xx but 
NOT MPT.

	Jeff



