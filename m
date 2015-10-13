From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 04/25] scsi: hisi_sas: add scsi host registration
Date: Tue, 13 Oct 2015 14:18:33 +0200
Message-ID: <5744202.hTVSbkLqE4@wuerfel>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com> <5053179.dHmgEztyeB@wuerfel> <561CCC07.2090901@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:59136 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbbJMMSp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2015 08:18:45 -0400
In-Reply-To: <561CCC07.2090901@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de

On Tuesday 13 October 2015 10:16:55 John Garry wrote:
> 
> >
> >> +       sha = SHOST_TO_SAS_HA(shost) = &hisi_hba->sha;
> >> +       platform_set_drvdata(pdev, sha);
> >> +
> >> +       phy_nr = port_nr = HISI_SAS_MAX_PHYS;
> >> +
> >> +       arr_phy = devm_kcalloc(dev, phy_nr, sizeof(void *), GFP_KERNEL);
> >> +       arr_port = devm_kcalloc(dev, port_nr, sizeof(void *), GFP_KERNEL);
> >> +       if (!arr_phy || !arr_port)
> >> +               return -ENOMEM;
> >
> > And since these are fixed-size arrays, they can be moved in there as well.
> >
> In a later patch we set as follows:
> phy_nr = port_nr = hisi_hba->n_phy;
> 
> You did say in our earlier private review that we could add statically 
> to hba strcut, but I commented that other vendors do similar so I would 
> wait for more input.

Ok, I forgot about that.

	Arnd

