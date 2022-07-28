Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F29C04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 21:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbiG1V6H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 17:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiG1V6G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 17:58:06 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A51F78590;
        Thu, 28 Jul 2022 14:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4CiV//V64/+5EInoNf64hhcAbSRTWriVVeP/Ntz6+jg=; b=YVOCaTxMc0vre0ReLDIMTSgMt2
        VEIR3nPdRJxtE/SB2hv3RUBpZtP/cUKF5rUgoBdk0HmhmQSJk5iJuN6FvsQnrGhHWINvZSKBsERmb
        Rnb8pm478nBkcekajsnOasnoecajzcboATpyhcL/7mTW3vZn+AJcTP9DEA4FzShwG+f35YKO0/N9i
        DePg3sYcz7aPSPrpKaAN8VDD3lF3I82VCGttLm8EhARePp0I2/Sd7TzLACbr3zRJIZOttO+81Jbfd
        4aQfj5xpbUzOa7G4g7Zlsbjz1P3Gjn38Kx3eHJlIuA0P6XQAG+GKMe14DvDlUuGJfKneOlvU39aQ6
        sx39ju2g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oHBW3-00Etk0-TK; Thu, 28 Jul 2022 21:57:59 +0000
Date:   Thu, 28 Jul 2022 14:57:59 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Chetan C R <quic_cchinnad@quicinc.com>
Cc:     bvanassche@acm.org, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V3] scsi: ufs: Get boot device storage type from command
 line
Message-ID: <YuMGZ5Nb9O96SNK3@infradead.org>
References: <1659034814-3473-1-git-send-email-quic_cchinnad@quicinc.com>
 <1659034814-3473-2-git-send-email-quic_cchinnad@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1659034814-3473-2-git-send-email-quic_cchinnad@quicinc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This code does not actually seem to have any user.  Why are you trying
to add dead code to the kernel?
