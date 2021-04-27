Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C980C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 12:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24011613C1
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 12:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236009AbhD0M2L convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 08:28:11 -0400
Received: from fgw21-4.mail.saunalahti.fi ([62.142.5.108]:30793 "EHLO
        fgw21-4.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235410AbhD0M2L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 08:28:11 -0400
X-Greylist: delayed 962 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Apr 2021 08:28:10 EDT
Received: from smtpclient.apple (87-92-207-71.rev.dnainternet.fi [87.92.207.71])
        by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
        id aeba7566-a751-11eb-9eb8-005056bdd08f;
        Tue, 27 Apr 2021 15:11:23 +0300 (EEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.80.0.2.43\))
Subject: Re: [PATCH 01/40] st: return error code in st_scsi_execute()
From:   =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= 
        <kai.makisara@kolumbus.fi>
In-Reply-To: <20210427083046.31620-2-hare@suse.de>
Date:   Tue, 27 Apr 2021 15:11:20 +0300
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <23468351-434A-42AE-BB52-B839A4B1085C@kolumbus.fi>
References: <20210427083046.31620-1-hare@suse.de>
 <20210427083046.31620-2-hare@suse.de>
To:     Hannes Reinecke <hare@suse.de>
X-Mailer: Apple Mail (2.3654.80.0.2.43)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On 27. Apr 2021, at 11.30, Hannes Reinecke <hare@suse.de> wrote:
> 
> The callers to st_scsi_execute already check for negative
> return values, so we can drop the use of DRIVER_ERROR and
> return the actual error code.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Acked-by: Kai Mäkisara <kai.makisara@kolumbus.fi>

