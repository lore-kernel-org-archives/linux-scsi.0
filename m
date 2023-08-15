Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1160C41513
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Aug 2023 23:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240589AbjHOXWL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Aug 2023 19:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240553AbjHOXVz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Aug 2023 19:21:55 -0400
Received: from ciao.gmane.io (ciao.gmane.io [116.202.254.214])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB81E7A
        for <linux-scsi@vger.kernel.org>; Tue, 15 Aug 2023 16:21:54 -0700 (PDT)
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <lnx-linux-scsi@m.gmane-mx.org>)
        id 1qW3MG-0004IA-WC
        for linux-scsi@vger.kernel.org; Wed, 16 Aug 2023 01:21:53 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-scsi@vger.kernel.org
From:   deloptes <emanoil.kotsev@deloptes.org>
Subject: Re: SSD SATA 3.3 and Broadcom / LSI SAS1068E PCI-Express Fusion-MPT SAS
Followup-To: gmane.linux.scsi
Date:   Wed, 16 Aug 2023 01:21:47 +0200
Message-ID: <ubh1ab$147i$1@ciao.gmane.io>
References: <ubgv7c$43t$1@ciao.gmane.io> <20230815231517.GA271814@bhelgaas>
Reply-To: emanoil.kotsev@deloptes.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8Bit
User-Agent: KNode/0.10.9
X-Face: &bB+dG6r\D$gd^NFeYm<f{n8m&2W,Lr'h>#MNOHtI/(z<->Su~)mL1rYXAE7W:U2d;tQAEP  ?3('tC@:iV_x)~3Kq.-X\\j1HU;i6/u\An"y=\gO%d`v#QdRgaw9JySH|xOp&6giT2q+z3j<t`[9@b  _&-<C%rE*@-)n9uI5?P_u9`8x.@SeM*h,'bBR~v^^XiU[Y&\/L6(jEpen8eNtlhu!p)GYOW6Iny
Cc:     linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bjorn Helgaas wrote:

> I saw some mention about BIOS knobs that controlled the minimum
> acceptable SATA link speed or something; that's the kind of thing I
> wondered about.
> 

You surely mean the SAS1068E controller. I'll have to look into the
documentation. Thanks for the advice.

>> As mentioned in the other posting I will attach those SSDs directly to
>> the mobo. There are 6 SATA ports there. I think this is the best
>> approach. But you know curiosity is a force you can not resist, so I
>> still want to know why?! :)
> 
> Haha, yeah, I know!  I noticed in your response to Sathya that you're
> running a 4.19.288 kernel, which is really, really old.  If it's
> practical, the first thing I would try is booting a current kernel,
> e.g., v6.4, on the chance that something has been fixed since v4.19.
> I didn't try to compare the mptsas driver to see if it has changed
> since then, so I don't know whether it's likely.

I'll check and try in any case. Thanks for the advice.

I'll report back in Sept.

BR

-- 
FCD6 3719 0FFB F1BF 38EA 4727 5348 5F1F DCFE BCB0

