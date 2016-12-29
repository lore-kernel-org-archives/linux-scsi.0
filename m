From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH v2 03/11] lpfc: Deprecate lpfc_soft_wwn parameter
Date: Thu, 29 Dec 2016 10:17:25 -0800
Message-ID: <311d9db9-0c69-5e1b-4763-fd58ff2ef8e0@broadcom.com>
References: <5858682a.Twfv0+hfi3tqtT1c%james.smart@broadcom.com>
 <20161222230059.000006e1@gmx.de>
 <1a6d026b-f896-84a9-2c81-9a3bfebd01dd@broadcom.com>
 <20161228193832.00000ba9@gmx.de>
 <f9fa4cfd-9a16-de65-ab71-65369791a29c@broadcom.com>
 <20161229074109.GA3322@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:35117 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752953AbcL2SR3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Dec 2016 13:17:29 -0500
Received: by mail-qt0-f172.google.com with SMTP id c47so378515723qtc.2
        for <linux-scsi@vger.kernel.org>; Thu, 29 Dec 2016 10:17:28 -0800 (PST)
In-Reply-To: <20161229074109.GA3322@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sebastian Herbszt <herbszt@gmx.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

ok.. I'll submit a patch to re-add the parameters, and add an 
appropriate "deprecation" warning

-- james


On 12/28/2016 11:41 PM, Christoph Hellwig wrote:
> Hi James,
>
> in Linux we have a pretty clear policy to avoid breaking existing real
> life userspace.  Given that Sebastian (and probably other users as well)
> make use of the soft WWN feature we can't just remove it.
>
> Which btw is what this patch does - deprecating is telling people to
> not use if, with the hopes of removing it in the future.  I think it
> would be fine to deprecate it with your above rational and print a
> warning to the kernel log, but we can't simply remove it.

