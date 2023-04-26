Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9660C77B60
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Apr 2023 23:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbjDZXHB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Apr 2023 19:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjDZXHA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Apr 2023 19:07:00 -0400
Received: from ns.iliad.fr (ns.iliad.fr [212.27.33.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242D12694;
        Wed, 26 Apr 2023 16:06:58 -0700 (PDT)
Received: from ns.iliad.fr (localhost [127.0.0.1])
        by ns.iliad.fr (Postfix) with ESMTP id 3735A203F1;
        Thu, 27 Apr 2023 01:06:56 +0200 (CEST)
Received: from sakura (freebox.vlq16.iliad.fr [213.36.7.13])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (3072 bits) server-digest SHA256)
        (No client certificate requested)
        by ns.iliad.fr (Postfix) with ESMTPS id 1D04C2029C;
        Thu, 27 Apr 2023 01:06:56 +0200 (CEST)
Date:   Thu, 27 Apr 2023 01:06:55 +0200
From:   Maxime Bizon <mbizon@freebox.fr>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-scsi@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Reproducible deadlock when usb-storage scsi command timeouts
 twice
Message-ID: <ZEmujxtkwV8wEhYh@sakura>
References: <ZEllnjMKT8ulZbJh@sakura>
 <34a2e50b-e899-45ee-ac14-31fa0bb1616b@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <34a2e50b-e899-45ee-ac14-31fa0bb1616b@rowland.harvard.edu>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On Wednesday 26 Apr 2023 à 15:20:07 (-0400), Alan Stern wrote:

> What version of the kernel are you using?

6.3

-- 
Maxime
