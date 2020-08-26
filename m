Return-Path: <SRS0=243Y=CE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D449EC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 09:12:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5742206FA
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 09:12:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbgHZJMt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Aug 2020 05:12:49 -0400
Received: from smtprelay0204.hostedemail.com ([216.40.44.204]:49552 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727906AbgHZJMs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Aug 2020 05:12:48 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 5F9B0180A68C8;
        Wed, 26 Aug 2020 09:12:47 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: field82_4a0e14027063
X-Filterd-Recvd-Size: 1581
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf13.hostedemail.com (Postfix) with ESMTPA;
        Wed, 26 Aug 2020 09:12:45 +0000 (UTC)
Message-ID: <8570915f668159f93ba2eb845a3bbc05f8ee3a99.camel@perches.com>
Subject: Re: [PATCH 17/19] z2ram: reindent
From:   Joe Perches <joe@perches.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Date:   Wed, 26 Aug 2020 02:12:43 -0700
In-Reply-To: <20200826062446.31860-18-hch@lst.de>
References: <20200826062446.31860-1-hch@lst.de>
         <20200826062446.31860-18-hch@lst.de>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-08-26 at 08:24 +0200, Christoph Hellwig wrote:
> reindent the driver using Lident as the code style was far away from
> normal Linux code.

Why?  Does anyone use this anymore?

 ** z2ram - Amiga pseudo-driver to access 16bit-RAM in ZorroII space
 **         as a block device, to be used as a RAM disk or swap space
 ** Copyright (C) 1994 by Ingo Wilken (Ingo.Wilken@informatik.uni-oldenburg.de)



