Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB586C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 06:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232402AbiGGG5v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 02:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbiGGG5u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 02:57:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB742DA90;
        Wed,  6 Jul 2022 23:57:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CC53B81F50;
        Thu,  7 Jul 2022 06:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB513C3411E;
        Thu,  7 Jul 2022 06:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657177066;
        bh=AItJJyeQjkhTz4SmoZsUS+OL3Gjs1hs5yIRFK5pBGOE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VGomatfwf0p/oZUl4xXDajJwd3wNLLz4tyzEHHgkULtKNdD6phtTPJ6rLbA1ZOpXe
         yptAy+DFrAVIu1yBfXki3cxePihg/TYW02mwX+CAZYYgLmk3S4wigwOEfVu54jVLHj
         043FLXRB3UAmw0HmWaToE9pFMieGK9UPSjvz2WLw=
Date:   Thu, 7 Jul 2022 08:57:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 20/36] usb: gadget: f_tcm: Limit number of sessions
Message-ID: <YsaD5lqtetyVBUD5@kroah.com>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
 <d344403eb32d950eafacf616ccc19ce742a6b3b6.1657149962.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d344403eb32d950eafacf616ccc19ce742a6b3b6.1657149962.git.Thinh.Nguyen@synopsys.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 06, 2022 at 04:36:28PM -0700, Thinh Nguyen wrote:
> Only allocate up to USBG_NUM_CMDS number of sessions.

Why?  This says what you do, but not why you are doing it.  You describe
the "why" quite well in earlier patches in this series, so please follow
that style here too :)

thanks,

greg k-h
