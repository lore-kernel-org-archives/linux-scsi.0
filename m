From: Loc Ho <lho@apm.com>
Subject: Re: [PATCH v2 3/5] ata: Add APM X-Gene SATA driver
Date: Mon, 11 Nov 2013 21:19:41 -0800
Message-ID: <CAPw-ZT=aVyw2yducpQMD2_rPPV7abKJZOH-Fs3bT2Ja=0tUNSQ@mail.gmail.com>
References: <1383980431-6572-1-git-send-email-lho@apm.com>
	<1383980431-6572-4-git-send-email-lho@apm.com>
	<CAOesGMjEpC9-i52zYb2LtmyfV7FZQQGeeo4Umg-LXOYytZ4E-A@mail.gmail.com>
	<201311110954.32904.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og117.obsmtp.com ([64.18.0.149]:44841 "HELO
	exprod5og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751645Ab3KLFTn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2013 00:19:43 -0500
Received: by mail-pb0-f44.google.com with SMTP id rp16so6334011pbb.31
        for <linux-scsi@vger.kernel.org>; Mon, 11 Nov 2013 21:19:42 -0800 (PST)
In-Reply-To: <201311110954.32904.arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Olof Johansson <olof@lixom.net>, Suman Tripathi <stripathi@apm.com>, linux-scsi@vger.kernel.org, Jon Masters <jcm@redhat.com>, Tejun Heo <tj@kernel.org>, Tuan Phan <tphan@apm.com>

Hi Arnd/Olof,

I looked over the phy code for USB and NET. There isn't such PHY
infrastructure for SATA from what I can tell. It seems like I will
need to put this all together. I am thinking about porting the USB
version over (with changes for SATA) and put it under
"./drivers/ata/phy". Any suggestion?

-Loc
