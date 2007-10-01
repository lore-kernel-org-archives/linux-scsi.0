From: Jeff Garzik <jeff@garzik.org>
Subject: Re: slave_configure for qlogicpti
Date: Mon, 01 Oct 2007 08:22:07 -0400
Message-ID: <4700E66F.40808@garzik.org>
References: <20070919124637.GE7624@parisc-linux.org>	<20070930.172952.85384131.davem@davemloft.net>	<470044DD.40100@garzik.org> <20070930.182412.08350831.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:44376 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbXJAMWK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Oct 2007 08:22:10 -0400
In-Reply-To: <20070930.182412.08350831.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: matthew@wil.cx, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org

David Miller wrote:
> From: Jeff Garzik <jeff@garzik.org>
> Date: Sun, 30 Sep 2007 20:52:45 -0400
> 
>> David Miller wrote:
>>> It compiles :-)  You deleted the only uses of scsi_rbuf_{get,put}()
>>> so you can kill those off too.
>>
>> Seeing as how they are exact duplicates of libata's 
>> ata_scsi_rbuf_{get,put}, I wonder how they got there in the first place 
>> (rather than becoming common code), and I wonder how many more copies 
>> are floating out there...
> 
> I bet: 1) they were common code in scsi_lib.c 2) qlogicpti and libata
> became the only remaining users so 3) they got copied to those
> two users verbatim anticipating that the qlogicpti usage would
> eventually be deleted.

I wrote the libata code from scratch, so I was just sorta curious.  No 
biggie either (read: I'm too lazy to search the history).

After the qlogicpti use goes away, libata-scsi is the remaining user of 
that logic.  The code is already local to libata, so... all good.

	Jeff



