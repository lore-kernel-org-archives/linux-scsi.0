From: Tejun Heo <htejun@gmail.com>
Subject: Re: PROBLEM: Tyan s2822 and SATA slowness / erratic speeds kernel
 2.6
Date: Wed, 16 Nov 2005 13:57:02 +0900
Message-ID: <437ABC1E.7040301@gmail.com>
References: <BAY108-F7B49C0F56D3AF2CD03DF4C05D0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=EUC-KR
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <BAY108-F7B49C0F56D3AF2CD03DF4C05D0@phx.gbl>
Sender: linux-ide-owner@vger.kernel.org
To: Jones Joneser <joneserstein@hotmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jones Joneser wrote:
> Machine:
> Tyan s2822G3NR-D
> Silicon Image, Inc. SiI 3114
> SATA Drives: Western Digital 300gb / seagate 80 gb
> 
> Initially we thought we had a network issue because we were seeing a 
> slowdown when transferring files > 512Mb in size (by whatever method: 
> rsync, cp, scp, etc.) between two of the Tyan servers, we see the first 
> 512Mb go at a decent rate (tens of megabytes per second) and then the 
> rate plummets to below 500k/sec.   However we reproduce the issue 
> locally on a machine thus eliminating the network card issue. We also 
> had tried with different ethernet cards and x-over cable.
> 
> 
> We are using CentOS 4 and have tried both 4.1 and 4.2 (the latest 
> edition) 64 and 32 bit.  We have tried ubuntu, gentoo, and vanilla 
> kernels.  We have upgraded our BIOS to the latest and experimented with 
> different BIOS settings (from 'safe' to 'optimal' with many variants in 
> between.) We have tried it with ACPI switched off, with 4gb of RAM and 
> with 8gb of RAM. We have upgraded the BIOS to 3.04 & then 3.05.  The 
> best we get is that under the ubuntu, gentoo, and a 2.4 kernel we can 
> see stable performance that is well below what we should be getting 
> ~20MiB/s.
> 
> No matter what combination of configuration we try, we consistently see 
> this issue.  We have even tried and LSI SATA controller w/ Tyan 
> motherboard and experienced the same issues.
> 
> We moved the SATA controller to a Dell PE 1750 and experience none of 
> the slowdowns, consistent ly 45-50MiB/s performance with no erraticness 
> in speed or drops in performance.
> 
> We suspect the issue is related to the combo of the Tyan mobo with the 
> SATA controller subsystem but need some assistance in further nailing 
> down the cause and solution to this issue.
> 
> Let me know of any additional information that I can provide to assist 
> with the debugging of this issue.
> 
> Thanks,
> -asher
> 

i. posting boot message would help.
ii. Can you try vanilla 2.6.14 kernel?  If it's sil m15w problem and
your card is 3114 but not 3112, the problem should disappear on 2.6.14.

-- 
tejun
