From: Denny Page <denny@cococafe.com>
Subject: Re: SCSI tape access on 2.6 kernels?
Date: Tue, 24 Jan 2006 11:43:37 -0800
Message-ID: <43D68369.1050307@cococafe.com>
References: <43D604AD.6050607@ilsb.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cococafe.com ([64.142.30.235]:21633 "EHLO
	mail.cococafe.com") by vger.kernel.org with ESMTP id S965002AbWAXTnl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jan 2006 14:43:41 -0500
In-Reply-To: <43D604AD.6050607@ilsb.tuwien.ac.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerhard Schneider <gs@ilsb.tuwien.ac.at>
Cc: linux-scsi@vger.kernel.org

Gerhard,

You may want to test earlier versions of 2.6.  There have been various 
reports of problems with scsi tape in later versions of the 2.6 kernel.  
I have problems beginning with 2.6.14 with U320 with LTO-2, others have 
reported problems going back to 2.6.12.

Denny


Gerhard Schneider wrote:
> It's getting me mad..
>
> It seems that with 2.6 (compared to 2.4) there has something been
> changed in the kernel that I'm not aware of so I'm not able to
> write/read tapes efficiently anymore..
>
> LSI1030 SCSI controller
> Overland tape library
> Seagate LTO-1 tape drive
>
> Kernel 2.4.29:
>
> dd if=linux-2.6.16-rc1.tar.gz of=/dev/nst0 bs=64k
> 776+1 records in
> 776+1 records out
> 50918460 bytes transferred in 4.620612 seconds (11019852 bytes/sec)
>
> Kernel 2.6.14rc1:
>
> dd if=linux-2.6.16-rc1.tar.gz of=/dev/nst0 bs=64k
> 776+1 records in
> 776+1 records out
> 50918460 bytes transferred in 20.395567 seconds (2496545 bytes/sec)
>
> Another machine w/
> LSI1030 SCSI controller
> Megaraid ZCR controller
> Overland tape library
> HP LTO-3 tape drive
> Kernel 2.6.14rc1:
>
> dd if=linux-2.6.16-rc1.tar.gz of=/dev/nst0 bs=64k
> 776+1 records in
> 776+1 records out
> 50918460 bytes transferred in 45.953133 seconds (1108052 bytes/sec)
>
> Either there is an initialization problems with tape drives on 2.6.*
> (I don't think so) or there are tunable kernel parameters that
> I don't know..
>
> CPU load on 2.6 is minimal, tape is waiting for data..
>
> Any idea? (I can provide you with any amount of data etc..)
>
>                                             GS
>
>   
