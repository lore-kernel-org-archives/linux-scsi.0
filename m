From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC PATCH 1/9] scsi-ml: modify change_queue_depth to take in
 reason why it is being called
Date: Fri, 28 Aug 2009 11:56:13 -0500
Message-ID: <4A980C2D.20707@cs.wisc.edu>
References: <20090826180234.23396.8148.stgit@vi1.jf.intel.com>	 <20090826180320.23396.70657.stgit@vi1.jf.intel.com>	 <20090827102135.GB5125@schmichrtp> <1251407368.14954.29.camel@vi2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51073 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714AbZH1Q4W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Aug 2009 12:56:22 -0400
In-Reply-To: <1251407368.14954.29.camel@vi2.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@linux.intel.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, Vasu Dev <vasu.dev@intel.com>, linux-scsi@vger.kernel.org

Vasu Dev wrote:
> On Thu, 2009-08-27 at 12:21 +0200, Christof Schmitt wrote:
>> On Wed, Aug 26, 2009 at 11:03:20AM -0700, Vasu Dev wrote:
>>> --- a/include/scsi/scsi_host.h
>>> +++ b/include/scsi/scsi_host.h
>>> @@ -43,6 +43,13 @@ struct blk_queue_tags;
>>>  #define DISABLE_CLUSTERING 0
>>>  #define ENABLE_CLUSTERING 1
>>>
>>> +enum {
>>> +	SCSI_QDEPTH_SYSFS_REQ,	/* user requested change through sysfs */
>>> +	SCSI_QDEPTH_QFULL,	/* scsi-ml requested due to queue full */
>>> +	SCSI_QDEPTH_RAMP_UP,	/* scsi-ml requested due to threshhold event */
>>> +	SCSI_QDEPTH_RAMP_DOWN, 	/* LLD/class requested due to lld/class event */
>>> +};
>>> +
>>>  struct scsi_host_template {
>>>  	struct module *module;
>>>  	const char *name;
>> I did not find SCSI_QDEPTH_RAMP_DOWN being used. Would a LLD use this
>> internally when changing the queue depth?
>>
> 
> Yes it is not used, should be removed before final patches unless Mike
> have plan to use this reason code.
> 

It might have been a goof up on my part. It is not needed.
