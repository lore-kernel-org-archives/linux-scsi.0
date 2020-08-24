Return-Path: <SRS0=xqUt=CC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDCF5C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 16:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7308206F0
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Aug 2020 16:57:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgHXQ5l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Aug 2020 12:57:41 -0400
Received: from mx2.suse.de ([195.135.220.15]:36358 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726548AbgHXQ4v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Aug 2020 12:56:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 67912AD6B;
        Mon, 24 Aug 2020 16:57:20 +0000 (UTC)
Date:   Mon, 24 Aug 2020 18:56:49 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [RFC PATCH] scsi: target: detect XCOPY NAA descriptor conflicts
Message-ID: <20200824185649.701f5855@suse.de>
In-Reply-To: <20200813002142.13820-1-ddiss@suse.de>
References: <20200813002142.13820-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ping - some feeback here would be much appreciated?

Cheers, David
