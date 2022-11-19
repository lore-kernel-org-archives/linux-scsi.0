Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7135C4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Nov 2022 19:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbiKSTDa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Nov 2022 14:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbiKSTD3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Nov 2022 14:03:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5083B113;
        Sat, 19 Nov 2022 11:03:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 081E760BA2;
        Sat, 19 Nov 2022 19:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB4FC433D6;
        Sat, 19 Nov 2022 19:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668884603;
        bh=aNHue5Wks1Ur1BATdAg3/nEnI63voyNMC4Y9A23H1Oo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tTWdY+c5bfkFu8/g3/lh19X3fHG2JkOxNUp1oezlDX4Rkn3ERGgm+ZY6fQfbM2ldR
         9tGC2q4kbcihjPgt736JzE+XKwS3R7LpKdjWs11DmYsJsF2rakNOwhJubr0yujKN7G
         yiznwvM7oPN/wGcPv+nf/AoOhkDXXVL1DXBr0Vt9pqZhmsZ+lV3weGTGNXg5H6d2pK
         iRFNSehi5YMWrADgPPWfgDBk9Q5CyRUkKtWHIeRGLYDDNmGYU+4ChNQ7M8wwE31uVd
         fOumbwuglDXjHm3VL/C0nhrze5twnQT9SrhWXQJLEbeN0k17Kb+RfswudQfM7Ga6oF
         Td7TWeK8fHx6Q==
Date:   Sat, 19 Nov 2022 13:03:10 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Nilesh Javali <njavali@marvell.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/2][next] scsi: qla2xxx: Replace one-element array with
 DECLARE_FLEX_ARRAY() helper
Message-ID: <Y3koblO7KIyteDFm@work>
References: <cover.1668814746.git.gustavoars@kernel.org>
 <faa40e6b31ecc9387ad1644bb1957aa53d7c682f.1668814746.git.gustavoars@kernel.org>
 <ef2881de-7843-97b5-8e0e-64c23ee168d8@wanadoo.fr>
 <Y3iaLCY68E6Stgrp@work>
 <629bac45-32c2-9eac-6fed-f2f9e39d2740@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <629bac45-32c2-9eac-6fed-f2f9e39d2740@wanadoo.fr>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Yes, I do agree, that the code is equivalent. I was surprised that a
> compiler was smart enough to generate the same binary code.

We discard the tiny changes that don't affect the logic or the control
flow of the program.

--
Gustavo
