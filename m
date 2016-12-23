From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH v2 03/11] lpfc: Deprecate lpfc_soft_wwn parameter
Date: Fri, 23 Dec 2016 08:44:56 -0800
Message-ID: <1a6d026b-f896-84a9-2c81-9a3bfebd01dd@broadcom.com>
References: <5858682a.Twfv0+hfi3tqtT1c%james.smart@broadcom.com>
 <20161222230059.000006e1@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:34164 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756234AbcLWQpA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Dec 2016 11:45:00 -0500
Received: by mail-qk0-f173.google.com with SMTP id h201so8178127qke.1
        for <linux-scsi@vger.kernel.org>; Fri, 23 Dec 2016 08:45:00 -0800 (PST)
In-Reply-To: <20161222230059.000006e1@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

I competes, without reasonable solutions to resolve which should be what 
at what time, with things like fabric-assigned wwn's as well as 
platform-oem name assignments via platform mechanisms.  Too many admin 
planes competing.

-- james


On 12/22/2016 2:00 PM, Sebastian Herbszt wrote:
> James Smart wrote:
>> Deprecate lpfc_soft_wwn parameter.
>> No longer allow override of hw-assigned wwns
>>
>> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
>> Signed-off-by: James Smart <james.smart@broadcom.com>
> Any reason to remove this functionality?
> I was actually using it.
>
> Sebastian

