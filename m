From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 29 Oct 2003 09:28:39 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F9FF8C7.70909@us.ibm.com>
References: <20031027153932.A16679@infradead.org> <018b01c39e1f$e013bab0$a0074d0a@apac.cisco.com> <20031029134557.A17523@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.101]:13246 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261294AbTJ2RaN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 12:30:13 -0500
In-Reply-To: <20031029134557.A17523@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: "Surekha.PC" <surekhap@cisco.com>, linux-scsi@vger.kernel.org, davmyers@cisco.com, Richard Bealkowski <ennui@us.ibm.com>

Hi Surekha,

>>This is again needed for network boot. The n/w driver and iSCSI driver
>>are loaded during early boot. Since the n/w interface is not setup at
>>that time, we need to bring up the interface through this call in iSCSI
>>driver.
> 
> 
> That's bogus.  Look at the ip autoconfig code used by rootnfs and reuse
> that instead of creating such bogus hacks.  A driver has no business dealing
> with the network configuration.
> 

Your driver does not even need to mess with that code. Just modify your 
usersapce tools in the linux-iscsi package that run in the initrd to do 
this in userspace.


Mike

