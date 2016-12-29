From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 03/11] lpfc: Deprecate lpfc_soft_wwn parameter
Date: Wed, 28 Dec 2016 23:41:09 -0800
Message-ID: <20161229074109.GA3322@infradead.org>
References: <5858682a.Twfv0+hfi3tqtT1c%james.smart@broadcom.com>
 <20161222230059.000006e1@gmx.de>
 <1a6d026b-f896-84a9-2c81-9a3bfebd01dd@broadcom.com>
 <20161228193832.00000ba9@gmx.de>
 <f9fa4cfd-9a16-de65-ab71-65369791a29c@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34220 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752532AbcL2HlM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2016 02:41:12 -0500
Content-Disposition: inline
In-Reply-To: <f9fa4cfd-9a16-de65-ab71-65369791a29c@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: Sebastian Herbszt <herbszt@gmx.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Hi James,

in Linux we have a pretty clear policy to avoid breaking existing real
life userspace.  Given that Sebastian (and probably other users as well)
make use of the soft WWN feature we can't just remove it.

Which btw is what this patch does - deprecating is telling people to
not use if, with the hopes of removing it in the future.  I think it
would be fine to deprecate it with your above rational and print a
warning to the kernel log, but we can't simply remove it.
