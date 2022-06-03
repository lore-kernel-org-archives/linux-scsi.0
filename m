Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08DFEC43334
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 05:54:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238885AbiFCFyu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 01:54:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241243AbiFCFyq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 01:54:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A98C369DD
        for <linux-scsi@vger.kernel.org>; Thu,  2 Jun 2022 22:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gT0cykWuOK0DxfgR4VfIGbcR4kR9KrPmXO7zMyWXFac=; b=qV1TGfrD0fL48CceKJTV2cC6XX
        VZAewJGX1IzMyfWG0anMMOMU57Z/lPeg9tRd9TcvHBpN6fAFZNxaWPT6ZbRjbXg/O63Q1NN4D/QiT
        x47SaVEu4l/zuhfr2f/J08NSqh2K/ovWZU7dj+R/eRX1Yw0UxcvOZNPWICPX8Ydl+4CXOdE8c+l2y
        zJFAHK81CH/iAxUEV7UhpnsP2lSkZLlLkipNYPjZKPtDc5PXyMM+yGfCPNIfslmX29hjhVuGFjcT3
        SOr9N0C1HxfNfrSi+nX7dgCwSBJRuoloXo6FlxGtOxLFw7F7Dwk8Xspny4RYgmle1jOFeEnKkc+mj
        eaUuWFgA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nx0Gj-005xda-9f; Fri, 03 Jun 2022 05:54:45 +0000
Date:   Thu, 2 Jun 2022 22:54:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Bunker <brian@purestorage.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi_lib: allow the ALUA transitioning state time to
 complete
Message-ID: <YpmiJVWpEumEfATd@infradead.org>
References: <CAHZQxyKMcCaquQ9n8pJ9tNb3HRZ2e14iXXojYS3C4=dB6NpUKQ@mail.gmail.com>
 <YpjTek7u+7+zFXzM@infradead.org>
 <CAHZQxyL9km19F+Pyv3DBeP7NHgg-m-zxNcw9gB97DTfeg_F=hA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHZQxyL9km19F+Pyv3DBeP7NHgg-m-zxNcw9gB97DTfeg_F=hA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 02, 2022 at 12:00:30PM -0700, Brian Bunker wrote:
> > > +       case ACTION_DELAYED_REPREP:
> > > +               scsi_io_completion_reprep(cmd, q, ALUA_TRANSITION_REPREP_DELAY);
> >
> > This is using spaces where it should use tabs.
> >
> 
> Like this then:

Looks your mailer actually converted all tabs to spaces..
