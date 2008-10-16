From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: Re: [PATCH 0/5] qla2xxx: Code Refactoring
Date: Thu, 16 Oct 2008 14:32:27 -0700
Message-ID: <86327215-E6E8-43BD-8DF1-2E352E99074D@qlogic.com>
References: <alpine.OSX.1.00.0810152210280.24642@ac-mac.local>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:47167 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240AbYJPVrq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Oct 2008 17:47:46 -0400
In-Reply-To: <alpine.OSX.1.00.0810152210280.24642@ac-mac.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: James.Bottomley@HansenPartnership.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org, linux-driver@qlogic.com

  On Oct 15, 2008, at 10:43 PM, Anirban Chakraborty wrote:

> Hi,
>
> We have refactored the qla2xxx FC driver in preparation for the  
> multi queue and
> future SR IOV hardware. Following changes are made to the driver.
>
> 1. scsi_qla_host structure has been changed to contain scsi host  
> specific
> data only.
> 2. A new structure, qla_hw_data is created to contain HBA specific  
> hardware data
> 3. Request and response IO specific data strucures are created.
> 4. Outstanding commands are now based to a request queue.
> 5. The global list of fcports for the hba is not maintained anymore,  
> instead
> a fcport list is construted on per scsi_qla_host.
> 6. start_scsi function is now accessed via function pointer from the
> isp_ops struct.
> 7. Interrupt handler registrations are done with the rsp_que, instead
> of the device id.
>
> Thank you,
> Anirban


Please note that the "From" address in these patches was set  
incorrectly as anirban@qlogic.com. It should be anirban.chakraborty@qlogic.com 
. I am sorry if this has caused any inconvenience to anyone.
Thanks a lot.
Anirban
