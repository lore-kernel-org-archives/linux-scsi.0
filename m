From: "Eric D. Mudama" <edmudama@gmail.com>
Subject: Re: Intel X25-M MLC SSD benchmarks
Date: Fri, 12 Dec 2008 08:55:27 -0700
Message-ID: <311601c90812120755s5981a659s2049db14a85f68e6@mail.gmail.com>
References: <20081210213937.GC25548@parisc-linux.org>
	 <83CA05F64804AF43B8F733C4ABDFAA51022D04D7@mail1.bitband.com>
	 <311601c90812111927t54ed6a54oac3154dba30f737d@mail.gmail.com>
	 <311601c90812112055i7ec955d6kf4fc13279817cdb0@mail.gmail.com>
	 <e2e108260812112315q5ed1d265q86cf22b1dd59c69d@mail.gmail.com>
	 <311601c90812120625o4e000646u98aebc8ab3556a33@mail.gmail.com>
	 <20081212152029.GL26095@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f12.google.com ([209.85.217.12]:53080 "EHLO
	mail-gx0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133AbYLLPzd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Dec 2008 10:55:33 -0500
In-Reply-To: <20081212152029.GL26095@parisc-linux.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, Raz Ben-Yehuda <razb@bitband.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 12/12/08, Matthew Wilcox <matthew@wil.cx> wrote:
> On Fri, Dec 12, 2008 at 07:25:18AM -0700, Eric D. Mudama wrote:
>> Oops, I guess I assumed that by writing a few gigabytes of data it
>> wouldn't matter that much.  I'll run the test again in a bit once I'm
>> off this solaris machine.
>
> You need to rescale for 2008; people often have 4GB or more RAM in their
> machines ... hell, I have one machine here from 2002 with 14GB in it
> (I don't power it up very often because it's too noisy).  The test was
> only writing 1GB of data, which would fit in the page cache of my laptop,
> never mind the kind of machine that's likely to have an 8-way array
> attached to it.

I just retested on a linux box at work, and got 79 MB/s on both the
X18-M and X25-M, and 197MB/s on an X25-E.  All were done with bs=1M
count=1000 oflag=direct.

--eric
