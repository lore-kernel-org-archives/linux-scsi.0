From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: Re: [PATCH 0/3] qla2xxx: fixes for 2.6.32-rc8
Date: Wed, 2 Dec 2009 12:36:09 -0800
Message-ID: <92FB3B2D-94E8-4C6E-B1A0-0EA6D61BF9AB@qlogic.com>
References: <1259779016-1762-1-git-send-email-giridhar.malavali@qlogic.com>
 <1259784260.5430.136.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:17265 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbZLBUgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2009 15:36:04 -0500
In-Reply-To: <1259784260.5430.136.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


On Dec 2, 2009, at 12:04 PM, James Bottomley wrote:

> On Wed, 2009-12-02 at 10:36 -0800, giridhar.malavali@qlogic.com wrote:
>> From: Giridhar Malavali <giridhar.malavali@qlogic.com>
>> 
>> Please apply...
>> 
>> Anirban Chakraborty (1):
>>  Fix to accommodate a hardware bug in multiqueue mode that does not
>>    work properly when acknowledgement of MSIX Interrupts is disabled.
> 
> OK, so this looks like a bug fix
This fix makes sure that MSIX interrupt acknowledgement is always turned on for multi- queue adapters where it does not work. Please apply it to the 2.6.31 stable branch also.

Thanks,
Anirban

