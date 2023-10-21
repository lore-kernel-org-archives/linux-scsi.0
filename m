Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33009C0032E
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Oct 2023 10:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjJUKTL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Oct 2023 06:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjJUKTK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 21 Oct 2023 06:19:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF717D41
        for <linux-scsi@vger.kernel.org>; Sat, 21 Oct 2023 03:19:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEFDC433C7;
        Sat, 21 Oct 2023 10:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1697883545;
        bh=o60ztdXoWebv4LHATyaCGzksZbO31/EhiedLC9VD11A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HUaP7ejO8hhcsuG4SLBiZQpoqKbhxbDiLxGf7+lnno7adChKbKrOleJY6QU+qZxsm
         bOlLKgNqJGITEG6jNMBGXIKLLbJilvvXMptbMOm40yGjeb653EZr4GBYYH8tLW58lJ
         2aEPdQBterdxVSrnqJJU49HZ+IHP4zsi406T75xU=
Date:   Sat, 21 Oct 2023 12:19:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-scsi@vger.kernel.org, stern@rowland.harvard.edu,
        oneukum@suse.com
Subject: Re: [PATCH 2/7] usb-storage,uas: make internal quirks flags 64bit
Message-ID: <2023102130-catfight-isolated-d786@gregkh>
References: <20231006125445.122380-1-gmazyland@gmail.com>
 <20231016072604.40179-1-gmazyland@gmail.com>
 <20231016072604.40179-3-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016072604.40179-3-gmazyland@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 16, 2023 at 09:25:59AM +0200, Milan Broz wrote:
> Switch internal usb-storage quirk value to 64-bit as quirks currently
> use all 32 bits.
> 
> (Following patches are needed to use driver_info with a 64-bit
> value properly.)

Nit, this sentence isn't needed, I'll go delete it when I apply it, and
patch 1/7 to my tree now, thanks.

greg k-h
