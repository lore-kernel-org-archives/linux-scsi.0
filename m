From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2/2] target: rename Kbuild files to Makefile
Date: Tue, 16 Nov 2010 12:32:47 +0200
Message-ID: <4CE25DCF.30408@panasas.com>
References: <20101115194325.GB23989@infradead.org>	 <1289853179.22107.114.camel@haakon2.linux-iscsi.org> <1289854531.22107.117.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:26983 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932793Ab0KPKcv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Nov 2010 05:32:51 -0500
In-Reply-To: <1289854531.22107.117.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

On 11/15/2010 10:55 PM, Nicholas A. Bellinger wrote:
> On Mon, 2010-11-15 at 12:32 -0800, Nicholas A. Bellinger wrote:
>> On Mon, 2010-11-15 at 14:43 -0500, Christoph Hellwig wrote:
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>>
>>
>> I was under the impression that $(srcdir)/Kbuild was the preferred
>> modern name..?
>>
> 
> This is in fact mainline convention, commited as 9093542.
> 
> Thanks!
> 
> --nab

[Rant below please ignore]

>From Documentation/kbuild/makefiles.txt

  === 3 The kbuild files

  Most Makefiles within the kernel are kbuild Makefiles that use the
  kbuild infrastructure. This chapter introduces the syntax used in the
  kbuild makefiles.
  The preferred name for the kbuild files are 'Makefile' but 'Kbuild' can
  be used and if both a 'Makefile' and a 'Kbuild' file exists, then the 'Kbuild'
  file will be used.

This has changed since the time I started. Back then that text was:
  The preferred name for the kbuild files are Kbuild

If I go to a random subdirectory in the Kernel and do:
[drivers/foo]$ make
With a Kbuild file it outputs:
make: *** No targets specified and no makefile found.  Stop.

With a Makefile it outputs:
make: *** No targets.  Stop.

Sigh! For me a "Makefile" is a make's makefile. Kbuild files are
not makefiles and should not be named as one.

But that's a lost cause
Boaz
