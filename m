From: George Magklaras <george.magklaras@biotek.uio.no>
Subject: Re: SCSI Disk layer performance
Date: Thu, 29 Jan 2004 13:26:50 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4018FC0A.3050309@biotek.uio.no>
References: <400FF79A.6050108@wanadoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.uio.no ([129.240.130.16]:62953 "EHLO pat.uio.no")
	by vger.kernel.org with ESMTP id S265895AbUA2M1p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2004 07:27:45 -0500
In-Reply-To: <400FF79A.6050108@wanadoo.es>
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose@wanadoo.es>, linux-scsi@vger.kernel.org



Xose Vazquez Perez wrote:
> Christoph Hellwig wrote:
> 
> 
>>What kernel tree do you use?  If you're looking for decent scsi
>>performance use linux 2.6 or the SuSE/RH vendor trees.  Stock Linux 2.4
> 
>                                            ^^^^^^
> _Enterprise_ kernels, RHEL or SLES.
> Fedora Core kernel is, more or less, a plain kernel.org.
> 
> I'm runnig RHEL 2.4.21-9.EL kernel and it's _much better_ than any 2.4.xx
> kernel.org. I could call it 2.5 because it's a mix of 2.4 and 2.6 ;-)
> 
The 2.4.21-9EL might have clever things backported into it, but it is 
still missing essential things that can make a difference in the block 
layer, like an anticipatory I/O schedule. My impression is that all 
2.4 kernels use the Linus Elevator. That works well with moderate SMP 
loads, but it does not perform well on my large-ish Hardware RAID0 
1.1Tbyte ext3 partition on a Power Vault 220S with a Dell PERC4 host 
adapter. The 2.6.1 does work a lot more better in that sense, giving 
me an average read of 90 Mbytes/sec as opposed to 
60+somethingMbytes/sec I used to get before with 2.4.21-9ELsmp.

The new I/O schedulers (let alone driver maturity issues) are the way 
to go for maximum performance! I won't place -for the moment- a 2.6 on 
a production grade system, but in a couple of releases, I will put 2.4 
in the museum :-) with respect to SCSI I/O performance.

Regards,
-- 
--
George B. Magklaras

Computer Systems Engineer/UNIX Systems Administrator
The Biotechnology Centre of Oslo




