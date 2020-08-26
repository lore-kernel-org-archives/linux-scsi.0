Return-Path: <SRS0=243Y=CE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD2FFC433E3
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 08:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 885F7206FA
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 08:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598429967;
	bh=9j9S6jD3DxMEcFAPuQIscdiwN8igL/aMRjgg1A+PMWI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=C7X9DLzaz5jptJGvtWC19ojbCVH06gikljI/SxZLSdMR2GkMG9lGb+i2bHPsX896C
	 4+JOG+BFMpISrS3090WEnrIkeG8zuCFyapsRfRct7NivCSPHwrNNTlcnNh93NXwzqr
	 ShmwEx+ovy6GQzgF5x6VRDmWaWB+3JPxl3b6hFaU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbgHZITZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Aug 2020 04:19:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbgHZITX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Aug 2020 04:19:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8967920678;
        Wed, 26 Aug 2020 08:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598429963;
        bh=9j9S6jD3DxMEcFAPuQIscdiwN8igL/aMRjgg1A+PMWI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SliejojpEfe07Yb7llCML/KuFhBA5CuWaOBDnXAAuPeT3RDbeIfq1yH2O5BjAzo8w
         a5nquc6gurtWUlvgN+T+jgYb/QeWe7fMbZukCpYy+G7IdeDRSl8huUt845/IHyWu4d
         PgM9pcoqPOBnu9HjvJc2vL3l3xZMzULh+6pTnPs8=
Date:   Wed, 26 Aug 2020 10:19:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH 02/19] block: merge drivers/base/map.c into block/genhd.c
Message-ID: <20200826081938.GC1796103@kroah.com>
References: <20200826062446.31860-1-hch@lst.de>
 <20200826062446.31860-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826062446.31860-3-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 26, 2020 at 08:24:29AM +0200, Christoph Hellwig wrote:
> Now that there is just a single user of the kobj_map functionality left,
> merge it into the user to prepare for additional simplications.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

YES!!!

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
