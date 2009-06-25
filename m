From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: [PATCH 6/6] fnic: Patch MAINTAINERS, scsi Makefile, scsi Kconfig
Date: Thu, 25 Jun 2009 12:04:42 -0700
Message-ID: <4A43CA4A.9050609@cisco.com>
References: <20090418012941.24787.58754.stgit@feynman.nuovasystems.com>	 <20090418013322.24787.53673.stgit@feynman.nuovasystems.com> <1245949235.4170.63.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2.cisco.com ([171.71.176.71]:11150 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZFYTEo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Jun 2009 15:04:44 -0400
In-Reply-To: <1245949235.4170.63.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Abhijeet Joglekar <abjoglek@cisco.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Fri, 2009-04-17 at 18:33 -0700, Abhijeet Joglekar wrote:
>> Patch MAINTAINERS file, add fnic module to scsi Makefile and Kconfig
>>
>> Signed-off-by: Abhijeet Joglekar <abjoglek@cisco.com>
>> Signed-off-by: Joe Eykholt <jeykholt@cisco.com>
>> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>> ---
>>  MAINTAINERS           |    8 ++++++++
>>  drivers/scsi/Kconfig  |   11 +++++++++++
>>  drivers/scsi/Makefile |    1 +
>>  3 files changed, 20 insertions(+), 0 deletions(-)
>>
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index ebaf77e..405f574 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -1167,6 +1167,14 @@ P:	Nils Faerber (port to kernel 2.4)
>>  M:	Nils Faerber <nils@kernelconcepts.de>
>>  S:	Maintained
>>  
>> +CISCO FCOE HBA DRIVER
>> +P:	Abhijeet Joglekar
>> +M:	abjoglek@cisco.com
>> +P:	Joe Eykholt
>> +M:	jeykholt@cisco.com
>> +L:	linux-scsi@vger.kernel.org
>> +S:	Supported
>> +
>>  CODA FILE SYSTEM
>>  P:	Jan Harkes
>>  M:	jaharkes@cs.cmu.edu
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index 876cd20..d45f3ad 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -628,6 +628,17 @@ config FCOE
>>  	---help---
>>  	  Fibre Channel over Ethernet module
>>  
>> +config FCOE_FNIC
>> +	tristate "Cisco FNIC Driver"
>> +	depends on PCI && X86
> 
> Why is this marked X86 only?  Surely as a PCIe card it should work on
> any architecture?

It isn't a standard PCIe card.  Currently that device is only used
in the Cisco UCS systems in a proprietary form-factor.

Mainly we don't want to test-build on all the other architectures
since it won't be usable on them.

	Regards,
	Joe


