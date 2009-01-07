From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 17/18] osd: Kconfig file for in-tree builds
Date: Wed, 07 Jan 2009 09:10:51 -0800
Message-ID: <4964E21B.6010403@oracle.com>
References: <49636507.8060808@panasas.com> <1231252344-24792-1-git-send-email-bharrosh@panasas.com> <4963978D.8060001@oracle.com> <49646C6A.3020304@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:59643 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbZAGRLZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2009 12:11:25 -0500
In-Reply-To: <49646C6A.3020304@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd ml <osd-dev@open-osd.org>, Andrew Morton <akpm@linux-foundation.org>

Boaz Harrosh wrote:
> Randy Dunlap wrote:
>> Boaz Harrosh wrote:
>>> Kconfig file for the drivers/scsi/osd subdirectory.
>>> Adds the following config items:
>>> 	config SCSI_OSD_INITIATOR
>>> 	config SCSI_OSD_ULD
>>> 	config SCSI_OSD_DPRINT_SENSE
>>> 	config SCSI_OSD_DEBUG
>>>
>>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>>> Reviewed-by: Benny Halevy <bhalevy@panasas.com>
>>> ---
>>>  drivers/scsi/osd/Kconfig |   53 ++++++++++++++++++++++++++++++++++++++++++++++
>>>  1 files changed, 53 insertions(+), 0 deletions(-)
>>>  create mode 100644 drivers/scsi/osd/Kconfig
>>>
>>> diff --git a/drivers/scsi/osd/Kconfig b/drivers/scsi/osd/Kconfig
>>> new file mode 100644
>>> index 0000000..861b5ce
>>> --- /dev/null
>>> +++ b/drivers/scsi/osd/Kconfig
>>> @@ -0,0 +1,53 @@
>>> +#
>>> +# Kernel configuration file for the OSD scsi protocol
>>> +#
>>> +# Copyright (C) 2008 Panasas Inc.  All rights reserved.
>>> +#
>>> +# Authors:
>>> +#   Boaz Harrosh <bharrosh@panasas.com>
>>> +#   Benny Halevy <bhalevy@panasas.com>
>>> +#
>>> +# This program is free software; you can redistribute it and/or modify
>>> +# it under the terms of the GNU General Public version 2 License as
>>> +# published by the Free Software Foundation
>>> +#
>>> +# FIXME: SCSI_OSD_INITIATOR should select CONFIG (HMAC) SHA1 somehow.
>>> +#        How is it done properly?
>> Probably similar to how net/sctp/Kconfig does it:
>>
>> 	select CRYPTO
>> 	select CRYPTO_HMAC
>> 	select CRYPTO_SHA1
>>
> 
> It is not yet relevant, I have not submitted the security code.
> But thanks, that looks doable. I have a question?
> When you do select, you must manually select the fixture you need plus
> all it's dependencies and their dependencies recursively, parents first?

'select' does not follow any dependency chains, so you need to
select all of them yourself.  I don't know that "parents first"
is required.

-- 
~Randy
