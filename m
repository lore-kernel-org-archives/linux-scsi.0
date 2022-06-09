Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 348DFC433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 15:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237587AbiFIPVv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jun 2022 11:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237328AbiFIPVu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2022 11:21:50 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613DB113A
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jun 2022 08:21:49 -0700 (PDT)
Date:   Thu, 9 Jun 2022 17:21:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1654788108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=omjTPz2H0uR6C7xmTEVSLT6daTFlh1F5NDtCkDH0azA=;
        b=yXpYrUWmTDrQFI7D10yqlY8c3VUfnMcNuVGK5yNrt3yoTwf2rm84k6Une8UXnFZoAkGyvW
        +t+u01H1A6KC1QblmLuOPkgwuNj/kGqP1YY1w0wib/W17+FJX5PMKBr3CM9V244TleDlJa
        MMWnxFrcWFKbJzKip2B/TGKs2aoLUQSqIL70ei5JjWOVNaga5WVbB0LCbxf4AuvpjeahCH
        n33Tlay9htZRZxICl1J+lZ3t2PqKhATc950d6D+DKMX7zHTepYKv6w0chR/lf3uiWr0uRv
        sBF3wiu5hGLHCCKo0mw6RFai6B8dKZ9yceegZuJqCf56IIABj3M3tcLeDzeHwQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1654788108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=omjTPz2H0uR6C7xmTEVSLT6daTFlh1F5NDtCkDH0azA=;
        b=rgEtwrwOsGEF2EOOZ23TnOPuVk68EDTdh+HI+0D6XGqHfzhA6EPBGAsjtE1QvVnB08g+89
        YN7q1/HG732Z2/DA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        ejb@linux.ibm.com, tglx@linutronix.de,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: Re: [PATCH 10/10] scsi/lpfc: Remove bogus references to discovery
 tasklet
Message-ID: <YqIQCmp0Ey2C4uzH@linutronix.de>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-11-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220530231512.9729-11-dave@stgolabs.net>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-05-30 16:15:12 [-0700], Davidlohr Bueso wrote:
> This is done as thread. Also remove an unused member of the
> lpfc_vport structure.

As per Documentation/scsi/ChangeLog.lpfc the tasklet usage was removed
in "20040515 to 20040526" and the driver was merged in 2005. It was
never used in the kernel.
Nice.

Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian
