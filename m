Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 065D5C43334
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Jun 2022 09:13:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238824AbiFGJNN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Jun 2022 05:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233281AbiFGJNL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2022 05:13:11 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC64C2E68D
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 02:13:10 -0700 (PDT)
Date:   Tue, 7 Jun 2022 11:13:07 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654593188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B87XTuKK3j1OKxYFVDvK33/vzcRJ4EbSUl4Gjz7S2ao=;
        b=bF9xKsfwee82Y+/BEzA/TdITYAs7YrJ6u2990oJ2pKC7Z0d25niZ2dVn9Ll29GqRZf00OC
        MEOTw0qtsqNwtD4JIN7NNL9P+pxD+WhsbalmIZVcUHYznBWWQBZkpLsw5+kgMc9pzUevFP
        eDi2hLYAouSnuYHwTuq+AfzOVc/h5/A3QTd3vVs7dZ4eTS6SiFobBMXg4LKQWEekbIAZJV
        20xCATkB+0+QOMLHxbtA9XhIpWq3kk1canXPs7sKsOXZ1w+/4D0WSa8BGeBWrfjr90BtBm
        x1Oy5AHzA3nVvalxxp2qAtkG563rTlrhZkrCuHLU/nZG1KOkKnn9FeV9wYz1CQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654593188;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B87XTuKK3j1OKxYFVDvK33/vzcRJ4EbSUl4Gjz7S2ao=;
        b=xGKMC9zRRo7L7wK3Z5eKH286gwI9wjxHn0B++4OJ8OUcg14UAvlrFHsV14y8+zBiYeCsFn
        P0AYaRWIBjDNa5CQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc:     Davidlohr Bueso <dave@stgolabs.net>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, ejb@linux.ibm.com, tglx@linutronix.de
Subject: Re: [PATCH 05/10] scsi/isci: Replace completion_tasklet with
 threaded irq
Message-ID: <Yp8Wo/w3l6XtC/MU@linutronix.de>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-6-dave@stgolabs.net>
 <c15b98e3-f1e5-79c9-3581-6b015b476cad@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c15b98e3-f1e5-79c9-3581-6b015b476cad@intel.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-06-06 12:24:22 [+0200], Artur Paszkiewicz wrote:
> Acked-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

Did you see my reply?

Sebastian
