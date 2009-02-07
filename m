From: Jeff Garzik <jeff@garzik.org>
Subject: Re: TRIM vs UNMAP vs WRITE SAME and thin devices
Date: Sat, 07 Feb 2009 18:46:42 -0500
Message-ID: <498E1D62.9070105@garzik.org>
References: <20090123041558.GC24652@parisc-linux.org> <4979AF62.7070409@redhat.com> <1232721777.4430.7.camel@macbook.infradead.org> <498DA052.6090605@redhat.com> <20090207224722.GA31509@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:54877 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbZBGXrE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 7 Feb 2009 18:47:04 -0500
In-Reply-To: <20090207224722.GA31509@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Ric Wheeler <rwheeler@redhat.com>, David Woodhouse <dwmw2@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <mkp@mkp.net>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>

Matthew Wilcox wrote:
> On Sat, Feb 07, 2009 at 09:53:06AM -0500, Ric Wheeler wrote:
>> I have been poked at by some vendors about the status of our support for 
>> the virtually/thinly provisioned luns since they are getting close to 
>> being able to test with real devices.
>>
>> My quick summary is that we most of the work so far has been done 
>> without any real hardware to play with - in 2.6.29-rc3, I don't see any 
>> low level ATA or SCSI bits that turn requests tagged with REQ_DISCARD 
>> into the specific ATA or SCSI commands. Did I miss something & if not, 
>> do we have plans to push anything upstream soonish?
> 
> Bearing in mind that I'm now three weeks behind on email, you might want
> to look at
> http://git.kernel.org/?p=linux/kernel/git/willy/ssd.git;a=shortlog;h=trim-20081231
> which has at least one known bug (fixed by Dave Woodhouse and Ben
> Herrenschmidt).  I'll be able to give a more coherent answer in a few
> days.  Or maybe Dave will beat me to it ;-)

BTW when will somebody send me the 4k sector patches?  :)

	Jeff



