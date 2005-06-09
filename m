From: Alexander Jolk <alexj@buf.fr>
Subject: Re: LSI MegaRAID SATA 300-X8 problems
Date: Thu, 09 Jun 2005 17:26:14 +0200
Message-ID: <42A85F96.5080608@buf.fr>
References: <42A5F235.6000300@buf.fr> <42A601E0.8090404@buf.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.buf.fr ([195.68.52.65]:5523 "EHLO mail.buf.fr")
	by vger.kernel.org with ESMTP id S261916AbVFIP0V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2005 11:26:21 -0400
Received: from srv1.pantin.buf.fr (srv1.pantin.buf.fr [172.21.0.241])
	by mail.buf.fr (8.12.3/8.12.3/Debian-7.1) with ESMTP id j59FQEdf026443
	for <linux-scsi@vger.kernel.org>; Thu, 9 Jun 2005 17:26:14 +0200
Received: from [172.21.0.11] (alexj@admin2.pantin.buf.fr [172.21.0.11])
	by srv1.pantin.buf.fr (8.13.1/8.13.1/Debian-20) with ESMTP id j59FQHd2028527
	for <linux-scsi@vger.kernel.org>; Thu, 9 Jun 2005 17:26:17 +0200
In-Reply-To: <42A601E0.8090404@buf.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Alexander Jolk wrote:
> Alexander Jolk wrote:
> 
>> I'm trying to get an LSI MegaRAID SATA 300-X8 controller to work on a 
>> Debian/sarge system with kernel 2.6.11-9-em64t-p4-smp from unstable. 
>> The megaraid_mbox module is loaded and seems to identify the 
>> controller, but whenever I try to access the disk, I get SCSI errors, 
>> the controller alarm goes off, and upon inspection in the BIOS, the 
>> first SATA disc is marked `FAILED'.  Reconfiguring the RAID lets me 
>> restart the whole process.
> 
> 
> Following up to myself, I compiled my own kernel 2.6.11.11 and things 
> appear to work so far.  Known problem that has been fixed, or worth 
> investigating?

Any pointers, anybody?  While things are working a little better, I 
still get a complete RAID crash every once in a while (a few hours of 
use, typically).  Since I have got no reaction so far, is more 
information needed, or should I take my questions somewhere else?  Where?

Alex


-- 
Alexander Jolk  * BUF Compagnie * alexj@buf.com
Tel +33-1 42 68 18 28  *  Fax +33-1 42 68 18 29
