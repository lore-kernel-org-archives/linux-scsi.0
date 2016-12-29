From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH v2 03/11] lpfc: Deprecate lpfc_soft_wwn parameter
Date: Wed, 28 Dec 2016 20:45:05 -0800
Message-ID: <f9fa4cfd-9a16-de65-ab71-65369791a29c@broadcom.com>
References: <5858682a.Twfv0+hfi3tqtT1c%james.smart@broadcom.com>
 <20161222230059.000006e1@gmx.de>
 <1a6d026b-f896-84a9-2c81-9a3bfebd01dd@broadcom.com>
 <20161228193832.00000ba9@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:35325 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751990AbcL2EpK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Dec 2016 23:45:10 -0500
Received: by mail-qk0-f173.google.com with SMTP id u25so252373430qki.2
        for <linux-scsi@vger.kernel.org>; Wed, 28 Dec 2016 20:45:09 -0800 (PST)
In-Reply-To: <20161228193832.00000ba9@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Sebastian,

"not portable" isn't the right way to describe it. It's not a 
chip-architecture issue, but rather that some oem platforms have 
side-band management that overrides anything that could have been done 
in the os, and in ways that may not be easy to communicate back to the 
driver.   FAWN - true Brocade only - but that is the 70+% market share 
of the FC switches. The current implementation already doesn't work many 
situations - so there's no clear winner for having it work everywhere. 
Given the inability for it always to work, the decision was to deprecate 
the attribute.

-- james


On 12/28/2016 10:38 AM, Sebastian Herbszt wrote:
> James Smart wrote:
>> I competes, without reasonable solutions to resolve which should be
>> what at what time, with things like fabric-assigned wwn's as well as
>> platform-oem name assignments via platform mechanisms.  Too many
>> admin planes competing.
>>
>> -- james
> FA-WWN seems to be fabric (and Brocade?) only and "platform mechanisms"
> are likely not portable. Soft wwn is a simple and flexible solution
> which works in fabric and loop configurations and is platform and
> server vendor agnostic. It already works with existing HBAs on x86 and
> should also work on PowerPC or SPARC systems.
> It is useful for initiators (hardware independence/mobility) and
> targets (transparent failover/floating wwn).
> Therefore I like to ask you to revert this patch and not introduce this
> functional regression.
>
> Sebastian

