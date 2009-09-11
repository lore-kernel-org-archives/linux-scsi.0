From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [PATCH 04/10] drivers: convert fc drivers calling scsi_track_queue_full
Date: Fri, 11 Sep 2009 13:00:22 -0700
Message-ID: <0BA09BCB-E5F6-4085-A575-0109B7FA7FD5@qlogic.com>
References: <20090903221910.24946.39993.stgit@vi1.jf.intel.com> <20090903222247.24946.60577.stgit@vi1.jf.intel.com> <412A05BA40734D4887DBC67661F433080FF72616@EXMAIL.ad.emulex.com> <1252100607.4516.35.camel@vi2.jf.intel.com> <4AAA80DD.5090001@cs.wisc.edu>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:26122 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbZIKUAU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2009 16:00:20 -0400
In-Reply-To: <4AAA80DD.5090001@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Vasu Dev <vasu.dev@linux.intel.com>, "Alex.Iannicelli@Emulex.Com" <Alex.Iannicelli@Emulex.Com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "vasu.dev@intel.com" <vasu.dev@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Smart@Emulex.Com" <James.Smart@Emulex.Com>, "robert.w.love@intel.com" <robert.w.love@intel.com>, "christof.schmitt@de.ibm.com" <christof.schmitt@de.ibm.com>

Mike,

I am looking at the changes. Will get back to you.

-- Giridhar.M.B

On Sep 11, 2009, at 9:54 AM, Mike Christie wrote:

> On 09/04/2009 04:43 PM, Vasu Dev wrote:
>> I agree all FC HBA should handle both ramp down and up as per added  
>> new
>> change_queue_depth interface by this series. I did this for libfc/ 
>> fcoe
>> and Chrirstof did this for zfcp driver but lpfc&  qla2xxx got only  
>> ramp
>> down changes from Mike, now that Mike is busy with other stuff I  
>> don't
>> know how to complete them in this series since I don't understand  
>> lpfc
>> and qla2xxx enough and neither I have way to test changes to these
>> drivers.
>
> The qla2xxxx conversion seems a lot easier than lpfc (at least a lot
> closer to what is being done in the common code Vasu added). I am
> attaching a patch made over this patchset that converts it to use the
> common ramp up code. I have only compile tested it.
>
> Andrew, could you have your guys give it a spin? Did you guys test out
> the rampdown/qfull handling?
> <0001-qla2xxx-hook-qla2xxx-into-common-ramp-up-code.patch>

