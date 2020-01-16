Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C501FC33CB1
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 11:43:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5D5A20730
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 11:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgAPLni convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 06:43:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:42808 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgAPLni (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Jan 2020 06:43:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 83B01AFF6;
        Thu, 16 Jan 2020 11:43:36 +0000 (UTC)
Date:   Thu, 16 Jan 2020 12:43:35 +0100
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Michael Reed <mdr@sgi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla1280: Fix dma firmware download, if dma
 address is 64bit
Message-Id: <20200116124335.43a679198f514cbdf7a929c4@suse.de>
In-Reply-To: <yq18sm8nitd.fsf@oracle.com>
References: <20200114160936.1517-1-tbogendoerfer@suse.de>
        <yq18sm8nitd.fsf@oracle.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 15 Jan 2020 23:09:34 -0500
"Martin K. Petersen" <martin.petersen@oracle.com> wrote:
 
> > Do firmware download with 64bit LOAD_RAM command, if driver is using
> > 64bit addressing.
> 
> Applied to 5.6/scsi-queue, thanks!

kbuild robot found an issue in the patch. Do you want a new version of
the patch or an incremental patch ?

Thomas.

-- 
SUSE Software Solutions Germany GmbH
HRB 36809 (AG Nürnberg)
Geschäftsführer: Felix Imendörffer
