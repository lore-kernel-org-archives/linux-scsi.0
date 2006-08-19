From: jassduec@gmail.com
Subject: RAID 5 throughputs
Date: Sat, 19 Aug 2006 11:46:08 -0600
Message-ID: <3a1eedb70608191046o7dd207bfp15f02e90b297b1a9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-admin-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-admin-owner@vger.kernel.org
To: linux-admin@vger.kernel.org, linux-config@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi All,

I have a storage system with 12 Maxtor 7200 rpm 250GB hard drives in
RAID 5 configuration with one hot spare. Maxtor claims that each drive
is capable of providing 56 MB/s sustained throughput. My host system
is connected to it using 64bit ultra320 Adaptec SCSI card. The host
system has 3.0 GHz pentium 4 (with HT) processor and 4 GB of RAM
running linux kernel 2.6.9. I was wondering what order of "maximum"
sequential read/write, random read/write throughput should i expect
using them. I am using some of the benchmarking tools like Bonnie,
Bonnie++, tiobench, dd, iometer etc. However the results from them
have been very depressing. Theoretically i should be able to achieve a
read sequential throughput close to min(10*56 = 560, 320) = 320 MB/s.
However my results are no way close to it. I was wondering if anybody
can give me some insight of what order of practical throughputs i
should expect using linux and what other factors may be creating
bottlenecks.

TIA
