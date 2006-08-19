From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: RAID 5 throughputs
Date: Sat, 19 Aug 2006 14:00:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0608191400080.17678@p34.internal.lan>
References: <3a1eedb70608191046o7dd207bfp15f02e90b297b1a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lucidpixels.com ([66.45.37.187]:8426 "EHLO lucidpixels.com")
	by vger.kernel.org with ESMTP id S1750739AbWHSSAe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Aug 2006 14:00:34 -0400
In-Reply-To: <3a1eedb70608191046o7dd207bfp15f02e90b297b1a9@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jassduec@gmail.com
Cc: linux-admin@vger.kernel.org, linux-config@vger.kernel.org, linux-scsi@vger.kernel.org



On Sat, 19 Aug 2006, jassduec@gmail.com wrote:

> Hi All,
>
> I have a storage system with 12 Maxtor 7200 rpm 250GB hard drives in
> RAID 5 configuration with one hot spare. Maxtor claims that each drive
> is capable of providing 56 MB/s sustained throughput. My host system
> is connected to it using 64bit ultra320 Adaptec SCSI card. The host
> system has 3.0 GHz pentium 4 (with HT) processor and 4 GB of RAM
> running linux kernel 2.6.9. I was wondering what order of "maximum"
> sequential read/write, random read/write throughput should i expect
> using them. I am using some of the benchmarking tools like Bonnie,
> Bonnie++, tiobench, dd, iometer etc. However the results from them
> have been very depressing. Theoretically i should be able to achieve a
> read sequential throughput close to min(10*56 = 560, 320) = 320 MB/s.
> However my results are no way close to it. I was wondering if anybody
> can give me some insight of what order of practical throughputs i
> should expect using linux and what other factors may be creating
> bottlenecks.
>
> TIA
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Is your 64bit ultra320 card in a 64bit PCI + 66MHZ slot?

If not, you will be limited to 133mb/s.

