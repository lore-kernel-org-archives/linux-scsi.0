From: Fabien Salvi <fabien@cri74.org>
Subject: Re: [IP over FC] qla2xipsrc perf (qla2x00ip driver)
Date: Wed, 16 Oct 2002 19:20:06 +0200
Sender: linux-net-owner@vger.kernel.org
Message-ID: <3DAD9FC6.BA4A4E78@cri74.org>
References: <233C89823A37714D95B1A891DE3BCE521423D7@xch-b.win.zambeel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-net-owner@vger.kernel.org>
To: Dheeraj Pandey <dheeraj@Zambeel.com>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Linux Net list <linux-net@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Dheeraj Pandey wrote:
> 
> ...
> > * with IP over FC :
> > I have around 21 MB/s performance using a big file (600 MB)
> > transfer by
> > FTP
> >
> > * with IP on Gigabit Ethernet :
> > I have around 33 MB/s with the same test using similar
> > conditions (same
> > file, same directory to store it).
> 
> Let us identify the bottleneck first. Is it the CPU0? Try observing "mpstat
> -P ALL" and see which one of the CPU's is loaded, if at all.
> 
> Its important we identify what resource saturates in the IP-over-FC case,
> which doesn't in the other.

Yes, you're right.

I should have give more informations about CPU utilization...
There is not really a CPU bottleneck I think.
I didn't use mpstat tool for that, but just top (thanks for your
information, I must admin I didn't know the mpstat tool...).

So, here are the results with IP over FC :
19:11:39     CPU   %user   %nice %system   %idle    intr/s
19:11:40     all    0.00    0.00   12.50   87.50   8033.00
19:11:40       0    0.00    0.00    4.00   96.00   8033.00
19:11:40       1    0.00    0.00   21.00   79.00   8033.00


And with Gigabit ethernet :

19:14:49     CPU   %user   %nice %system   %idle    intr/s
19:14:50     all    0.00    0.00   26.00   74.00  14432.00
19:14:50       0    0.00    0.00   40.00   60.00  14432.00
19:14:50       1    0.00    0.00   12.00   88.00  14432.00

Thanks in advance for your help !

-- 
Fabien SALVI      Centre de Ressources Informatiques
                  Archamps, France -- http://www.cri74.org
                  PingOO GNU/linux distribution : http://www.pingoo.org
