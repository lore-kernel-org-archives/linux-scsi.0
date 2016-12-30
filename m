From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH v2 03/11] lpfc: Deprecate lpfc_soft_wwn parameter
Date: Fri, 30 Dec 2016 07:21:34 -0800
Message-ID: <140c5c03-8515-8a20-6823-4f7ac16bed52@broadcom.com>
References: <5858682a.Twfv0+hfi3tqtT1c%james.smart@broadcom.com>
 <20161222230059.000006e1@gmx.de>
 <1a6d026b-f896-84a9-2c81-9a3bfebd01dd@broadcom.com>
 <20161228193832.00000ba9@gmx.de>
 <f9fa4cfd-9a16-de65-ab71-65369791a29c@broadcom.com>
 <20161230003152.000056b7@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:35325 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754167AbcL3PVj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Dec 2016 10:21:39 -0500
Received: by mail-qt0-f182.google.com with SMTP id c47so396742114qtc.2
        for <linux-scsi@vger.kernel.org>; Fri, 30 Dec 2016 07:21:38 -0800 (PST)
In-Reply-To: <20161230003152.000056b7@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>


On 12/29/2016 3:31 PM, Sebastian Herbszt wrote:
> "not portable" might not be the term I actually meant. Let's call it
> server vendor dependent.
> Can you please elaborate on the oem platforms and side-band management
> you mean? I know of a solution called "ServerView Virtual-IO Manager"
> by Fujitsu which might fit. AFAIK it is a piece of software which
> communicates with the BMC and allows to change the MAC address and WWN.
> Of course it only works with Fujitsu servers and supported cards.
> I think I heard that for NICs it just changes the MAC address in the
> eeprom. This is not done "online" but when the server is powered on.
> Even though this might be a comparable case (external MAC address
> configuration) I think the ability to change the MAC address by the
> means of "ip link set dev ethX address" was not removed.

Unfortunately, I can't elaborate on the platforms. Yes, there are things 
similar to what you describe above. Also realize that persisting the 
value across different cold/hot/flr resets affects boot and dump.

> How do you choose the desired WWN between the possible options
> (factory set, oem platform set, FA-WWN)?
> And wouldn't soft wwn always win because it is applied at last?
> However it might compete with FA-WWN. I wasn't yet able to
> find details on how it works.
>
> Sebastian

Unfortunately, I can't comment on that either.  It's not always last 
wins and that's one of the issues.

I've submitted a patch to reinstated the feature - it works as well as 
it did before.

-- james

