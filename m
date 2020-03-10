Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C19C7C10F27
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 17:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5EC520727
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 17:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgCJRnb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 13:43:31 -0400
Received: from ms.lwn.net ([45.79.88.28]:44314 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbgCJRnb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 13:43:31 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 996C8823;
        Tue, 10 Mar 2020 17:43:29 +0000 (UTC)
Date:   Tue, 10 Mar 2020 11:43:28 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Matthew Wilcox <willy@infradead.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Kai =?UTF-8?B?TcOka2lzYXJh?= <Kai.Makisara@kolumbus.fi>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        megaraidlinux.pdl@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        esc.storagedev@microsemi.com, Doug Gilbert <dgilbert@interlog.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Hannes Reinecke <hare@suse.com>, dc395x@twibble.org,
        Oliver Neukum <oliver@neukum.org>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Khalid Aziz <khalid@gonehiking.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Jamie Lenehan <lenehan@twibble.org>,
        Ali Akcaagac <aliakc@web.de>,
        Don Brace <don.brace@microsemi.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Avri Altman <avri.altman@wdc.com>,
        GOTO Masanori <gotom@debian.or.jp>
Subject: Re: [PATCH 00/42] Manually convert SCSI documentation to ReST
 format
Message-ID: <20200310114328.6354cffb@lwn.net>
In-Reply-To: <cover.1583136624.git.mchehab+huawei@kernel.org>
References: <cover.1583136624.git.mchehab+huawei@kernel.org>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon,  2 Mar 2020 09:15:33 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> This patch series manually convert all SCSI documentation files to ReST.
> 
> This is part of a bigger series that finaly finishes the migration to ReST.
> After that, we can focus on more interesting tasks from the documentation
> PoV, like cleaning obsolete stuff and filling the gaps.
> 
> If you want to see how this would show at the documentation body,
> a sneak peak of this series (together with the other pending
> doc patches from me) is available at:
> 
>         https://www.infradead.org/~mchehab/kernel_docs/scsi/index.html
> 
> This series is available on this devel branch:
> 
>         https://git.linuxtv.org/mchehab/experimental.git/log/?h=scsi_docs_20200228
> 
> and it is based on next-20200228

Any thoughts from the SCSI maintainers on this series?  Assuming you're
favorable, would you like to carry it or should I?

Thanks,

jon
