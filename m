Return-Path: <SRS0=lsQb=4L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A2AAC35671
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Feb 2020 19:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4C3C206ED
	for <linux-scsi@archiver.kernel.org>; Sun, 23 Feb 2020 19:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgBWT5Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Feb 2020 14:57:25 -0500
Received: from hosting.gsystem.sk ([212.5.213.30]:53468 "EHLO
        hosting.gsystem.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgBWT5Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Feb 2020 14:57:25 -0500
Received: from [192.168.0.2] (188-167-68-178.dynamic.chello.sk [188.167.68.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hosting.gsystem.sk (Postfix) with ESMTPSA id 5ED857A00BF;
        Sun, 23 Feb 2020 20:57:23 +0100 (CET)
From:   Ondrej Zary <linux@zary.sk>
To:     Bart Van Assche <bvanassche@acm.org>
Subject: Re: NULL pointer dereference in qla24xx_abort_command, kernel 4.19.98 (Debian)
Date:   Sun, 23 Feb 2020 20:57:15 +0100
User-Agent: KMail/1.9.10
Cc:     qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <202002231929.01662.linux@zary.sk> <12dcd970-2aa6-2a9a-0f8c-029201ea84df@acm.org>
In-Reply-To: <12dcd970-2aa6-2a9a-0f8c-029201ea84df@acm.org>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202002232057.16101.linux@zary.sk>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sunday 23 February 2020 20:26:39 Bart Van Assche wrote:
> On 2020-02-23 10:29, Ondrej Zary wrote:
> > a couple of days after upgrading a server from Debian 9 (kernel 4.9.210-1)
> > to 10 (kernel 4.19.98), qla2xxx crashed, along with mysql.
> > 
> > There is an EMC CX3 array connected through the fibre-channel adapter.
> > No errors are present in EMC event log.
> > 
> > This server was running without any problems since Debian 4.
> > Is this a known bug?
> 
> Please report issues encountered with Debian kernels in the Debian bug
> tracker. If you want the upstream community to assist please retest with
> an upstream kernel.

Debian kernel does not have any patches related to qla2xxx driver:
https://salsa.debian.org/kernel-team/linux/raw/debian/4.19.98-1/debian/patches/series

It crashed after running for 11 days. Not a quick&easy test.

-- 
Ondrej Zary
