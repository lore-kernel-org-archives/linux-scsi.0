Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0672C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 05:13:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234644AbiDHFP7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 01:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiDHFP5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 01:15:57 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8371D2EB461
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 22:13:55 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1458C68AFE; Fri,  8 Apr 2022 07:13:52 +0200 (CEST)
Date:   Fri, 8 Apr 2022 07:13:51 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        bvanassche@acm.org, hch@lst.de, sathya.prakash@broadcom.com,
        kashyap.desai@broadcom.com, chandrakanth.patil@broadcom.com,
        sreekanth.reddy@broadcom.com, prayas.patel@broadcom.com
Subject: Re: [PATCH v3 3/8] mpi3mr: move MPI headers to uapi/scsi/mpi3mr
Message-ID: <20220408051351.GA31826@lst.de>
References: <20220407192913.345411-1-sumit.saxena@broadcom.com> <20220407192913.345411-4-sumit.saxena@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220407192913.345411-4-sumit.saxena@broadcom.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 07, 2022 at 03:29:08PM -0400, Sumit Saxena wrote:
> MPI headers are used by user space applications so
> it makes sense to move them to uapi/scsi/mpi3mr.

I think this is a horrible idea.  These headers are a huge and a bit of
a mess, and no we need to provide uapi guarantees for them.
