From: Mark Bellon <mbellon@mvista.com>
Subject: Re: Qlogic driver hang
Date: Thu, 02 Oct 2003 11:25:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F7C6D9C.2000205@mvista.com>
References: <B179AE41C1147041AA1121F44614F0B060ED34@AVEXCH02.qlogic.org>	 <1065109530.24236.6127.camel@localhost.localdomain> <1065118590.4779.158.camel@persist.az.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([12.44.186.158]:10224 "EHLO
	av.mvista.com") by vger.kernel.org with ESMTP id S263431AbTJBSZf
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2003 14:25:35 -0400
In-Reply-To: <1065118590.4779.158.camel@persist.az.mvista.com>
List-Id: linux-scsi@vger.kernel.org
To: sdake@mvista.com
Cc: Chris Worley <cworley@lnxi.com>, linux-scsi@vger.kernel.org

>
>
>At one point some code was added to enable parity on the chip.  This may
>be the cause of the hang.  Try disabling parity checking in the driver.
>
>On Thu, 2003-10-02 at 08:45, Chris Worley wrote:
>  
>
>>In using the 6.06.00 version of the qlogic driver, the module load gets
>>to:
>>
>>	Verifying chip...      
>>
>>And hangs the system.  The older driver would print out:
>>
>>	Firmware version:  3.01.13, Driver version 6.01.00
>>
>>at this point.  Any ideas what I'm doing wrong?
>>    
>>
There is a known problem in some hardware implementations of the 2312 
and possibly other
chips - parity errors in the firmware RAM will lock up a system. The 
last time I looked the public driver did not have a configuration option 
to do this. If it's not there let me know and I can dig the lines up for 
you to try.

mark


