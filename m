From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/8] scsi_transport_iscsi: Exporting new attrs for iscsi
 session and connection in sysfs
Date: Tue, 28 May 2013 11:02:58 -0500
Message-ID: <51A4D532.8080705@cs.wisc.edu>
References: <3FC4AB8B47ECD546BCD4B361A64BEACD30EEFEC2@avmb3.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46006 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934639Ab3E1QDJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 May 2013 12:03:09 -0400
In-Reply-To: <3FC4AB8B47ECD546BCD4B361A64BEACD30EEFEC2@avmb3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

On 05/28/2013 06:55 AM, Vikas Chaudhary wrote:
> 
> 
> -----Original Message-----
> From: Mike Christie <michaelc@cs.wisc.edu>
> Date: Tuesday 28 May 2013 2:27 PM
> To: Vikas <vikas.chaudhary@qlogic.com>
> Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, scsi
> <linux-scsi@vger.kernel.org>, Lalit Chandivade
> <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Adheer
> Chandravanshi <adheer.chandravanshi@qlogic.com>
> Subject: Re: [PATCH 4/8] scsi_transport_iscsi: Exporting new attrs for
> iscsi session and connection in sysfs
> 
>> On 05/09/2013 05:02 AM, vikas.chaudhary@qlogic.com wrote:
>>> +	ISCSI_PARAM_DEF_TASKMGMT_TMO,
>>
>> We currently have:
>>
>>        ISCSI_PARAM_ABORT_TMO,
>>        ISCSI_PARAM_LU_RESET_TMO,
>>        ISCSI_PARAM_HOST_RESET_TMO,
>>
>>
>> Does your card just have the one timeout for all types of tmfs?
>>
>> I think the interface to set timers for the different eh operations
>> should be generic.
> 
> We have added TASKMGMT_TMO as our adapter sets single TMO for all task
> management commands.
> Let us know if its ok or not?
> 

I was thinking maybe a better name to reflect that it is for all tmfs,
but I think it is ok.

