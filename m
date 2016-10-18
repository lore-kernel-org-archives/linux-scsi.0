From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 07/20] scsi_transport_fc: rename 'fc_rport_create' to
 'fc_remote_port_create'
Date: Tue, 18 Oct 2016 10:29:57 -0700
Message-ID: <b33d2c30-478c-6d6b-597e-297dc4d54396@broadcom.com>
References: <1476777714-3543-1-git-send-email-hare@suse.de>
 <1476777714-3543-8-git-send-email-hare@suse.de>
 <488ec5c6-3c64-d9e4-d8d1-42676b666b32@broadcom.com>
 <CAGH8bx6+ZPAQRM1hWbEnzWj8qRJAcF7g3ne6oTbeWvbkXNtnvA@mail.gmail.com>
 <CAGH8bx4Aut8NJ4t48yXv6+LJxfKvXFMOtzEm7UBuCqo-BwSEMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:35416 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933658AbcJRRaF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2016 13:30:05 -0400
Received: by mail-pf0-f179.google.com with SMTP id s8so225486pfj.2
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2016 10:30:05 -0700 (PDT)
In-Reply-To: <CAGH8bx4Aut8NJ4t48yXv6+LJxfKvXFMOtzEm7UBuCqo-BwSEMA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <morbidrsa@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Bart van Assche <bart.vanassche@sandisk.com>, Johannes Thumshirn <jth@kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>



On 10/18/2016 9:18 AM, Johannes Thumshirn wrote:
>
> Hi James,
>
> fc_rport_create() in scsi_transport_fc.c is static so there is no 
> interface change here.
>
> Johannes
>

ah - that this was the published routine.  ok.

-- james

