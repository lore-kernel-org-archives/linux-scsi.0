Return-Path: <SRS0=qdS7=42=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 928CAC10F27
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 16:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 712F52465A
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 16:44:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727171AbgCIQoI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Mar 2020 12:44:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:48052 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbgCIQoH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 9 Mar 2020 12:44:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0252CB311;
        Mon,  9 Mar 2020 16:44:06 +0000 (UTC)
Message-ID: <880107864f597f6518b893db97f746b3ec4d39cb.camel@suse.com>
Subject: Re: [PATCH v2 0/3] scsi: qla2xxx: fixes for driver unloading
From:   Martin Wilck <mwilck@suse.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     Bart Van Assche <Bart.VanAssche@sandisk.com>,
        Daniel Wagner <dwagner@suse.de>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org
Date:   Mon, 09 Mar 2020 17:44:10 +0100
In-Reply-To: <20200205214422.3657-1-mwilck@suse.com>
References: <20200205214422.3657-1-mwilck@suse.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Martin, Himanshu,

On Wed, 2020-02-05 at 22:44 +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Hello Martin, Himanshu, all,
> 
> here is v2 of the little series I first submitted on Nov 29, 2019.
> 
> Changes wrt v2:
>  - Added patch 3 to set the UNLOADING flag before waiting for
> sessions
>    to end (Roman)
>  - Use test_and_set_bit() for UNLOADING (Hannes)
> 
> Martin Wilck (3):
>   scsi: qla2xxx: avoid sending mailbox commands if firmware is
> stopped
>   scsi: qla2xxx: don't shut down firmware before closing sessions
>   scsi: qla2xxx: set UNLOADING before waiting for session deletion
> 
>  drivers/scsi/qla2xxx/qla_mbx.c |  3 +++
>  drivers/scsi/qla2xxx/qla_os.c  | 39 +++++++++++++++++---------------
> --
>  2 files changed, 22 insertions(+), 20 deletions(-)
> 

what about this series? Will it be merged for 5.7? It got positive
reviews from Daniel, and no negative ones so far, and it still applies
cleanly to 5.7/scsi-queue.

Thanks,
Martin W.



