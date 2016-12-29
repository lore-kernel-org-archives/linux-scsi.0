From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH v2 03/11] lpfc: Deprecate lpfc_soft_wwn parameter
Date: Fri, 30 Dec 2016 00:31:52 +0100
Message-ID: <20161230003152.000056b7@gmx.de>
References: <5858682a.Twfv0+hfi3tqtT1c%james.smart@broadcom.com>
        <20161222230059.000006e1@gmx.de>
        <1a6d026b-f896-84a9-2c81-9a3bfebd01dd@broadcom.com>
        <20161228193832.00000ba9@gmx.de>
        <f9fa4cfd-9a16-de65-ab71-65369791a29c@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:49920 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751416AbcL2XcP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Dec 2016 18:32:15 -0500
In-Reply-To: <f9fa4cfd-9a16-de65-ab71-65369791a29c@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sebastian Herbszt <herbszt@gmx.de>

James,

thank you for taking the time to answer me.

James Smart wrote:
> Sebastian,
> 
> "not portable" isn't the right way to describe it. It's not a 
> chip-architecture issue, but rather that some oem platforms have 
> side-band management that overrides anything that could have been
> done in the os, and in ways that may not be easy to communicate back
> to the driver.

"not portable" might not be the term I actually meant. Let's call it
server vendor dependent.
Can you please elaborate on the oem platforms and side-band management
you mean? I know of a solution called "ServerView Virtual-IO Manager"
by Fujitsu which might fit. AFAIK it is a piece of software which
communicates with the BMC and allows to change the MAC address and WWN.
Of course it only works with Fujitsu servers and supported cards.
I think I heard that for NICs it just changes the MAC address in the
eeprom. This is not done "online" but when the server is powered on.
Even though this might be a comparable case (external MAC address
configuration) I think the ability to change the MAC address by the
means of "ip link set dev ethX address" was not removed.

> FAWN - true Brocade only - but that is the 70+%
> market share of the FC switches. The current implementation already
> doesn't work many situations - so there's no clear winner for having
> it work everywhere. Given the inability for it always to work, the
> decision was to deprecate the attribute.
> 
> -- james

How do you choose the desired WWN between the possible options
(factory set, oem platform set, FA-WWN)?
And wouldn't soft wwn always win because it is applied at last?
However it might compete with FA-WWN. I wasn't yet able to
find details on how it works.

Sebastian
