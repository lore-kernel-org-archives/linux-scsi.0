From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: REGRESSION in 2.6.13-rc1: Massive slowdown with Adaptec SCSI
Date: Tue, 5 Jul 2005 11:08:17 +1000
Message-ID: <17097.56705.490622.759154@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:665 "EHLO
	note.orchestra.cse.unsw.EDU.AU") by vger.kernel.org with ESMTP
	id S261743AbVGEBIa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jul 2005 21:08:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


Hi,
 I have a server with a:
        SCSI storage controller: Adaptec AHA-3960D / AIC-7899A U160/m (rev 01)
        Subsystem: Adaptec AHA-3960D U160/m

 connected to 14 
      Vendor: MAXTOR   Model: ATLAS15K_36SCA   Rev: DTA0

 7 on each channel.

 On  2.6.12  a simple 'dd' write test gives 70 Meg/second:

cage #  time dd of=/dev/null if=/dev/sdl bs=1024k count=100
100+0 records in
100+0 records out
104857600 bytes transferred in 1.555210 seconds (67423431 bytes/sec)

real    0m1.557s
user    0m0.001s
sys     0m0.770s


 On 2.6.13-rc1 the same test takes just short on 1 minute and reports
 slightly less than 2 M/Second.

cage #  time dd of=/dev/null if=/dev/sdl bs=1024k count=100
100+0 records in
100+0 records out
104857600 bytes transferred in 54.576592 seconds (1921293 bytes/sec)

real    0m54.578s
user    0m0.000s
sys     0m0.360s

I'm happy to try patches or perform other tests.

NeilBrown
