From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [Announce] smp_utils-0.91 available
Date: Fri, 25 Aug 2006 18:53:14 -0400
Message-ID: <44EF7F5A.5050806@torque.net>
References: <664A4EBB07F29743873A87CF62C26D702BD839@NAMAIL4.ad.lsil.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:30374 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1422742AbWHYWxW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Aug 2006 18:53:22 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D702BD839@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

Moore, Eric wrote:
> On Wednesday, August 23, 2006 8:11 AM, Douglas Gilbert wrote:
> 
>> Two interfaces are available: the "mptctl" pass through used
>> by MPT Fusion SAS HBAs and the "smp_portal" sysfs attribute
>> pass through used by at least one aic94xx based Linux driver.
>>
> 
> It doesn't seem to work when I have more than one fusion controller.
> What is the command line option for passing the ioc number?

Eric,
Try '/dev/mptctl,<ioc_num>'. For example:

# smp_rep_general /dev/mptctl,2

If the ',<ioc_num>' is not given ioc_num 0 is assumed.


Doug Gilbert
