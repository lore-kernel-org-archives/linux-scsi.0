Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8378C001E0
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Oct 2023 10:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjJUKWJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Oct 2023 06:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjJUKWI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Oct 2023 06:22:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09C9D41
        for <linux-scsi@vger.kernel.org>; Sat, 21 Oct 2023 03:21:56 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36119C433C8;
        Sat, 21 Oct 2023 10:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1697883716;
        bh=oyimhO7suVSvnWfKQSXAKUTFdnT5bdgyjfYlp1W2ZK8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wlOdTiTJis7AomBYjgLISv/Vzl6/PFKf2fu7XEIHlqbjOyUK5sOx2duXx0pSLFsX7
         k5QUOhx+jTzgIwtRK9SSq2ueAFGdLLJOm3s+lrMuyIBpW1G/NbX/l4HYWdq1lG/o2c
         2w2e7zm6ZS0Z6WLAtQspa7lP8GzIbNtpQ3YRNwwk=
Date:   Sat, 21 Oct 2023 12:21:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-scsi@vger.kernel.org, stern@rowland.harvard.edu,
        oneukum@suse.com
Subject: Re: [PATCH 5/7] usb-storage,uas: do not convert device_info for
 64-bit platforms
Message-ID: <2023102110-waviness-corny-7bd6@gregkh>
References: <20231006125445.122380-1-gmazyland@gmail.com>
 <20231016072604.40179-1-gmazyland@gmail.com>
 <20231016072604.40179-6-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016072604.40179-6-gmazyland@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 16, 2023 at 09:26:02AM +0200, Milan Broz wrote:
> This patch optimizes the previous one for 64-bit platforms,

What is "previous one"?  We don't know that when we go and look at the
changelog in the future.

> where
> unsigned long is 64-bit, so we do not need to convert quirk flags
> to 32-bit index.
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>

Why not just do it properly the first time?  You are fixing up a patch
that you added, which should not be needed.

thanks,

greg k-h
