From: Fabien Salvi <fabien@cri74.org>
Subject: [IP over FC] qla2xipsrc perf (qla2x00ip driver)
Date: Wed, 16 Oct 2002 17:18:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DAD8363.AEA8AA43@cri74.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI list <linux-scsi@vger.kernel.org>, Linux Net list <linux-net@vger.kernel.org>

Hello,

Sorry for cross-posting to the 2 lists, but I think this topic can
concerns both...

I've made some tests on IP over FC.

Here are the elements :

- 2 high-perf servers with RAID SCSI disks, 1 GB RAM, dual PIII
processors and a 2.4.18 SMP enabled linux kernel
- 2 Qlogic qla2200f HBAs
- 1 Qlogic Sanbox2 FC switch
- 2 Intel optical Gigabit ethernet NIC

The 2 servers are connected to the FC switch with optical links.
There is a crossover cable between the 2 gigabit NIC

First, it's really great to use FC switch also for IP data, it's useful
when using NFS access mixed with Data on external FC RAID controller
(for the moment shared file system are not as reliable as we would like
and GFS is no more opensource).
For example, you can have some unique datas for each server and some
data (ie web data, etc...) for both, and using failover script, you can
have the survivor mounting the partition of the dead server and no
service failure...

So, no problem to compile and load qlogic driver.
Tests haven't shown any problems with reliability.

The only thing that surprise me is performance issues using FC over IP.

* with IP over FC :
I have around 21 MB/s performance using a big file (600 MB) transfer by
FTP

* with IP on Gigabit Ethernet :
I have around 33 MB/s with the same test using similar conditions (same
file, same directory to store it).

I renewed a lot of time the tests to be sure they are not altered with
I/O access and swap problems.
There were no other activities on the FC switch.

So, why do I have these performance issues ?
Is it inherant to the IP over FC architecture, to the qlogic driver ?
Is there any tuning ?

Thanks in advance for your help...

-- 
Fabien
