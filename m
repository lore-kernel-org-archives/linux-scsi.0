Return-Path: <SRS0=Cwhq=XT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DC46C432C2
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 07:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07160214D9
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Sep 2019 07:23:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409259AbfIXHXk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Sep 2019 03:23:40 -0400
Received: from mail.monom.org ([188.138.9.77]:44822 "EHLO mail.monom.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390189AbfIXHXk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Sep 2019 03:23:40 -0400
Received: from mail.monom.org (localhost [127.0.0.1])
        by filter.mynetwork.local (Postfix) with ESMTP id 94181500114;
        Tue, 24 Sep 2019 09:23:38 +0200 (CEST)
Received: from localhost (b9168f76.cgn.dg-w.de [185.22.143.118])
        by mail.monom.org (Postfix) with ESMTPSA id 60A865000E6;
        Tue, 24 Sep 2019 09:23:38 +0200 (CEST)
Date:   Tue, 24 Sep 2019 09:23:37 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     "QLogic-Storage-Upstream@cavium.com" 
        <QLogic-Storage-Upstream@cavium.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: qedf: Add port_id getter
Message-ID: <20190924072337.rfmgmyw2pjoi2lgx@beryllium.lan>
References: <20190923103738.67749-1-dwagner@suse.de>
 <MN2PR18MB25273EBD439B3458D6088610D2840@MN2PR18MB2527.namprd18.prod.outlook.com>
 <20190924071138.pifkyd75xhrminnt@beryllium.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190924071138.pifkyd75xhrminnt@beryllium.lan>
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Saurav,

On Tue, Sep 24, 2019 at 09:11:38AM +0200, Daniel Wagner wrote:
> On Tue, Sep 24, 2019 at 06:08:09AM +0000, Saurav Kashyap wrote:
> > > +static void qedf_get_host_port_id(struct Scsi_Host *shost) {
> > > +	struct fc_lport *lport = shost_priv(shost);
> > > +
> > > +	fc_host_port_id(shost) = lport->port_id; }
> > 
> > Minor stuff, the closing brace should be in next line. Please submit v2.
> 
> Oops, sorry about that.

The patch I sent out had the closing brace on a new
line:

https://lore.kernel.org/linux-scsi/20190923103738.67749-1-dwagner@suse.de/

Now I am a bit confused how I screwed it up. Anyway, I'll send it out
again after with hexdump there is not a special ASCII character
hidden :)

Thanks,
Daniel
