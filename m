From: Dheeraj Pandey <dheeraj@Zambeel.com>
Subject: RE: [IP over FC] qla2xipsrc perf (qla2x00ip driver)
Date: Wed, 16 Oct 2002 08:37:51 -0700
Sender: linux-net-owner@vger.kernel.org
Message-ID: <233C89823A37714D95B1A891DE3BCE521423D7@xch-b.win.zambeel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-net-owner@vger.kernel.org>
To: 'Fabien Salvi' <fabien@cri74.org>, Linux SCSI list <linux-scsi@vger.kernel.org>, Linux Net list <linux-net@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


...
> * with IP over FC :
> I have around 21 MB/s performance using a big file (600 MB) 
> transfer by
> FTP
> 
> * with IP on Gigabit Ethernet :
> I have around 33 MB/s with the same test using similar 
> conditions (same
> file, same directory to store it).

Let us identify the bottleneck first. Is it the CPU0? Try observing "mpstat
-P ALL" and see which one of the CPU's is loaded, if at all.

Its important we identify what resource saturates in the IP-over-FC case,
which doesn't in the other.

Dheeraj
