Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 761ECC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 16:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BF7D23403
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 16:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbhAGQop (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 11:44:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:35100 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728123AbhAGQop (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 11:44:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610037839; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qTgd9UuBZqZycDjK3sD9teLAb1GP/0SCrjHstBQGs/g=;
        b=C2daNc1rOQ5Q70ER2I/xeaGaGgdh9ifA+JNWS8fQXXTwWxy7b86+fg0wPBbTofZXmpq9Zk
        RCTag+A4auUgj9aJ6a+BctWWA8j7I2aUAktZpO7Bl3zLlZq58w6J7Z8oawXyOKS/7ScL+I
        G4DsZvtoNFw8CMWsXOX+jMLY5ckyy8k=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 19EDAB765;
        Thu,  7 Jan 2021 16:43:59 +0000 (UTC)
Message-ID: <0210c63eabb6cb56e9a966e42c969b64e1360cb3.camel@suse.com>
Subject: Re: [PATCH V3 03/25] smartpqi: refactor build sg list code
From:   Martin Wilck <mwilck@suse.com>
To:     Don Brace <don.brace@microchip.com>, Kevin.Barnett@microchip.com,
        scott.teel@microchip.com, Justin.Lindley@microchip.com,
        scott.benesh@microchip.com, gerry.morong@microchip.com,
        mahesh.rajashekhara@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com
Cc:     linux-scsi@vger.kernel.org
Date:   Thu, 07 Jan 2021 17:43:58 +0100
In-Reply-To: <160763247773.26927.3560789968206627155.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763247773.26927.3560789968206627155.stgit@brunhilda>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-12-10 at 14:34 -0600, Don Brace wrote:
> * No functional changes.
> * Factor out code common to all s/g list building.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>

Hint: readability would be improved if you could remove the
"goto out" statements in pqi_build_raid_sg_list() and
pqi_build_aio_sg_list(). That should go into a separate patch,
though.

Reviewed-by: Martin Wilck <mwilck@suse.com>



