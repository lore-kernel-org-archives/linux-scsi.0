From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH v2 03/11] lpfc: Deprecate lpfc_soft_wwn parameter
Date: Wed, 28 Dec 2016 19:38:32 +0100
Message-ID: <20161228193832.00000ba9@gmx.de>
References: <5858682a.Twfv0+hfi3tqtT1c%james.smart@broadcom.com>
        <20161222230059.000006e1@gmx.de>
        <1a6d026b-f896-84a9-2c81-9a3bfebd01dd@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:54889 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751475AbcL1Sjk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Dec 2016 13:39:40 -0500
In-Reply-To: <1a6d026b-f896-84a9-2c81-9a3bfebd01dd@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> I competes, without reasonable solutions to resolve which should be
> what at what time, with things like fabric-assigned wwn's as well as 
> platform-oem name assignments via platform mechanisms.  Too many
> admin planes competing.
> 
> -- james

FA-WWN seems to be fabric (and Brocade?) only and "platform mechanisms"
are likely not portable. Soft wwn is a simple and flexible solution
which works in fabric and loop configurations and is platform and
server vendor agnostic. It already works with existing HBAs on x86 and
should also work on PowerPC or SPARC systems.
It is useful for initiators (hardware independence/mobility) and
targets (transparent failover/floating wwn).
Therefore I like to ask you to revert this patch and not introduce this
functional regression.

Sebastian
