Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29595C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 18 May 2022 22:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiERWOr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 May 2022 18:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiERWOp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2022 18:14:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6926B205254;
        Wed, 18 May 2022 15:14:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A7202CE221A;
        Wed, 18 May 2022 22:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62099C385A9;
        Wed, 18 May 2022 22:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652912079;
        bh=u74yg/M4Fxkx9BQwfM3eTdqX2f0fV4spwaVbAhO6bhc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dfSXkoFUfztPS2hYCcdSVFN5LcY9J3A6JSb2MUk9rXsB9pPGDp5W5X/5YHpP+jZFC
         2hbS6vY3ktiRoibpZFRW1S8shUJYYBiJ0c1WI7VHSap5kgIlMWIW/l9vlwTbgSYSyN
         Wlct7D6l0qJz62W7XK5n8XZ5HLPNLZofDQZG7pbEULy3sh0rI0XmGywcEDwT847NWV
         1oM5KQwa0JpLHM2QBuvLO4OBT9xprxSdEhiVSsY81RSnuK2XFqnTUwlgTtcShdaeUw
         ugsdce279EmFkq7qzG8DZb0qexWdwoeP+5485rFGGcR43hoek0KrNsdxzbU0UjBGDu
         F1wevXVj6+uWw==
Date:   Wed, 18 May 2022 16:14:34 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: cleanup blk_execute_rq*
Message-ID: <YoVvyviy3eJolJ3+@kbusch-mbp.dhcp.thefacebook.com>
References: <20220517064901.3059255-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220517064901.3059255-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series looks good to me.

Reviewed-by: Keith Busch <kbusch@kernel.org>
