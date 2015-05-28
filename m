From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Subject: Re: [PATCH v6 9/9] snic:Add Makefile, patch Kconfig, MAINTAINERS
Date: Thu, 28 May 2015 18:01:30 +0000
Message-ID: <D18D5553.268B2%nmusini@cisco.com>
References: <1432711182-17530-1-git-send-email-nmusini@cisco.com>
 <1432711182-17530-10-git-send-email-nmusini@cisco.com>
 <1432821316.2199.14.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-5.cisco.com ([173.37.86.76]:12074 "EHLO
	rcdn-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbbE1SBb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 May 2015 14:01:31 -0400
In-Reply-To: <1432821316.2199.14.camel@HansenPartnership.com>
Content-Language: en-US
Content-ID: <368BC595FDC96848A26730099E30F4EF@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>

Hi James,

    Thank you for reviewing the patches.
    Sure, I will incorporate your comments and suggestions in next patch
submittal.


On 28/05/15 7:25 pm, "James Bottomley"
<James.Bottomley@HansenPartnership.com> wrote:

>In general, patch is much better: it passes all the static checker tests
>for byte width and endianness issues.  However
>
>On Wed, 2015-05-27 at 00:19 -0700, Narsimhulu Musini wrote:
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index 9c92f41..8baab3f 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -634,6 +634,23 @@ config FCOE_FNIC
>>  	  <file:Documentation/scsi/scsi.txt>.
>>  	  The module will be called fnic.
>>  
>> +config SCSI_SNIC
>> +	tristate "Cisco SNIC Driver"
>> +	depends on PCI && SCSI && X86_64
>
>Please don't restrict the compilation architecture in the Kconfig
>because that restricts the amount of build testing the driver gets.
>Instead you can put a runtime warning in the driver if you insist.
>Something like this
>
>http://thread.gmane.org/gmane.linux.scsi/101846
>
>Where you add a runtime taint is much better.
Sure, I will add runtime taint. Thanks for suggesting it.
>
>James
>
>
Thanks
Narsimhulu
>

