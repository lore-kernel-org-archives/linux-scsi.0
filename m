From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [Open-FCoE] [PATCH v3] scsi-ml: adds queue_depth ramp up code
Date: Wed, 21 Oct 2009 09:11:18 -0400
Message-ID: <4ADF0876.9070407@emulex.com>
References: <20091016004700.22451.42962.stgit@vifc.jf.intel.com>	<20091016230824.18916.84116.stgit@vifc.jf.intel.com>	<20091020185426.GA5905@schmichrtp.de.ibm.com>	<1256077937.16472.60.camel@vi2.jf.intel.com> <4ADE444D.5090307@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:50559 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbZJUNLU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2009 09:11:20 -0400
In-Reply-To: <4ADE444D.5090307@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: Vasu Dev <vasu.dev@linux.intel.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, Christof Schmitt <christof.schmitt@de.ibm.com>, "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



Joe Eykholt wrote:
> Vasu Dev wrote:
>> On Tue, 2009-10-20 at 20:54 +0200, Christof Schmitt wrote:
>>> I would prefer having seconds or milliseconds in sysfs and only using
>>> jiffies internally.
>>>
>> Added timestamp comparison checks are straightforward without any
>> additional conversion on each check since added timestamps and
>> queue_ramp_up_period both are jiffies, so works better this way with
>> stored queue_ramp_up_period in jiffies. 
>>
>> I do see your point as well but jiffies unit is also common in Linux.
>> However if you or some other feels strongly to change this to ms or
>> seconds unit then I could change store or show sysfs functions to handle
>> this value in ms or second unit while storing it in jiffies in
>> queue_ramp_up_period.
>>
>> 	Vasu
> 
> I agree with Christof on this, HZ may be 100 on some machines and 1000
> on others.  Management tools (if they ever adjust this) would like
> standard units, so it should be in ms or seconds, and I prefer ms.
> I would just change the sysfs functions as you say, and use jiffies internally.
> 
> 	Joe

I'll third this request - specifying in jiffies is a non-distinct value from 
platform to platform.  ms or seconds is preferred.

-- james
