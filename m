Return-Path: <SRS0=Cwhq=XT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8652C432C1
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 07:17:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C364F214AF
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 07:17:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409256AbfIXHRP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Sep 2019 03:17:15 -0400
Received: from mail.monom.org ([188.138.9.77]:44788 "EHLO mail.monom.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403882AbfIXHRP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Sep 2019 03:17:15 -0400
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Sep 2019 03:17:14 EDT
Received: from mail.monom.org (localhost [127.0.0.1])
        by filter.mynetwork.local (Postfix) with ESMTP id 2ABB5500114;
        Tue, 24 Sep 2019 09:11:42 +0200 (CEST)
Received: from localhost (b9168f76.cgn.dg-w.de [185.22.143.118])
        by mail.monom.org (Postfix) with ESMTPSA id EAE2F5000E6;
        Tue, 24 Sep 2019 09:11:41 +0200 (CEST)
Date:   Tue, 24 Sep 2019 09:11:38 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     "QLogic-Storage-Upstream@cavium.com" 
        <QLogic-Storage-Upstream@cavium.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: qedf: Add port_id getter
Message-ID: <20190924071138.pifkyd75xhrminnt@beryllium.lan>
References: <20190923103738.67749-1-dwagner@suse.de>
 <MN2PR18MB25273EBD439B3458D6088610D2840@MN2PR18MB2527.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR18MB25273EBD439B3458D6088610D2840@MN2PR18MB2527.namprd18.prod.outlook.com>
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 24, 2019 at 06:08:09AM +0000, Saurav Kashyap wrote:
> > +static void qedf_get_host_port_id(struct Scsi_Host *shost) {
> > +	struct fc_lport *lport = shost_priv(shost);
> > +
> > +	fc_host_port_id(shost) = lport->port_id; }
> 
> Minor stuff, the closing brace should be in next line. Please submit v2.

Oops, sorry about that.

Thanks
Daniel
