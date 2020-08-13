Return-Path: <SRS0=CV/f=BX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472C9C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 11:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D29F20866
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 11:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgHMLI2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Aug 2020 07:08:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:56846 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726072AbgHMLI1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Aug 2020 07:08:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EDE65B6A5;
        Thu, 13 Aug 2020 11:08:47 +0000 (UTC)
Date:   Thu, 13 Aug 2020 13:08:25 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [RFC PATCH] scsi: target: detect XCOPY NAA descriptor conflicts
Message-ID: <20200813130825.67cf86d0@suse.de>
In-Reply-To: <20200813002142.13820-1-ddiss@suse.de>
References: <20200813002142.13820-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

FWIW, tcmu-runner appears to use the same vpd_unit_serial -> NAA WWN
mapping logic. I'll provide a patch for it too, once we decide on the
best way to address this issue.

Cheers, David
