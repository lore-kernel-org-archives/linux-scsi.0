From: "Raz Ben-Yehuda" <razb@bitband.com>
Subject: RE: Intel X25-M MLC SSD benchmarks
Date: Fri, 12 Dec 2008 19:12:31 +0200
Message-ID: <83CA05F64804AF43B8F733C4ABDFAA51022D04DE@mail1.bitband.com>
References: <311601c90812120755s5981a659s2049db14a85f68e6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.bitband.com ([213.8.50.174]:53627 "EHLO mail.bitband.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759453AbYLLRMm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Dec 2008 12:12:42 -0500
Content-class: urn:content-classes:message
In-Reply-To: <311601c90812120755s5981a659s2049db14a85f68e6@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Eric D. Mudama" <edmudama@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org



-----Original Message-----
From: Eric D. Mudama [mailto:edmudama@gmail.com] 
Sent: Friday, December 12, 2008 5:55 PM
To: Matthew Wilcox
Cc: Bart Van Assche; Raz Ben-Yehuda; linux-ide@vger.kernel.org;
linux-scsi@vger.kernel.org
Subject: Re: Intel X25-M MLC SSD benchmarks

On 12/12/08, Matthew Wilcox <matthew@wil.cx> wrote:
> On Fri, Dec 12, 2008 at 07:25:18AM -0700, Eric D. Mudama wrote:
>> Oops, I guess I assumed that by writing a few gigabytes of data it
>> wouldn't matter that much.  I'll run the test again in a bit once I'm
>> off this solaris machine.
>
> You need to rescale for 2008; people often have 4GB or more RAM in
their
> machines ... hell, I have one machine here from 2002 with 14GB in it
> (I don't power it up very often because it's too noisy).  The test was
> only writing 1GB of data, which would fit in the page cache of my
laptop,
> never mind the kind of machine that's likely to have an 8-way array
> attached to it.

>>I just retested on a linux box at work, and got 79 MB/s on both the
>>X18-M and X25-M, and 197MB/s on an X25-E.  All were done with bs=1M
>>count=1000 oflag=direct.

What is the serial number of your x25.M ? 
what controller ? 
How new is it ? 
Please dd all disk and then retest, just to be sure you used all erase
blocks. 

--<<eric
