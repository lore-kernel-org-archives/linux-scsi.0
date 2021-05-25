Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11154C47085
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 13:27:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2A2B6143C
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 13:27:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbhEYN3B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 09:29:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:37540 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233367AbhEYN1g (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 May 2021 09:27:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1621949165; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+4aBrhqhsJ0cIj4ikBhKVV6Rdd3i26Twb4VIOVQvtmg=;
        b=swEL0iA0gRihqBQQzsTxXR5fSWR5je8UYHoRPf7rgO424/YqD2yAHE2taIPKJbofZ0l8r2
        JT4M6BlO2gVqj+1XifNiYArVaPwkZ9oWbGC/SNQ03sRqQFFYsMiH6pIRRYnn215elMlW91
        OgR3AIbaUpzbf/hJuQA368qJ68KW8Pk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1621949165;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+4aBrhqhsJ0cIj4ikBhKVV6Rdd3i26Twb4VIOVQvtmg=;
        b=O7vs5QbLcZMSeFLaRR8geVrnEvVwHp7CS3BOVHHU8ZfQ+tr/jOrvit+VW9cmOCpU0gvdoU
        3TYakJp6JLazIHCg==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4CC11AB71;
        Tue, 25 May 2021 13:26:05 +0000 (UTC)
Date:   Tue, 25 May 2021 15:26:04 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     GR-QLogic-Storage-Upstream@marvell.com,
        linux-kernel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Arun Easi <aeasi@marvell.com>
Subject: Re: [RFC 0/2] Serialize timeout handling and done callback.
Message-ID: <20210525132604.dpn56mga2otyaxwl@beryllium.lan>
References: <20210507123103.10265-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210507123103.10265-1-dwagner@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Fri, May 07, 2021 at 02:31:00PM +0200, Daniel Wagner wrote:
> Maybe they make sense to add the driver even if I don't have prove it
> really address the mentioned bug hence this is marked as RFC.

Any feedback?

Thanks,
Daniel
