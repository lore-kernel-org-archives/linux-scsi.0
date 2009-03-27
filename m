From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] config: Make need for SCSI_CDROM clearer
Date: Fri, 27 Mar 2009 10:36:22 +0100
Message-ID: <E1Ln8UB-0001SM-50@be1.7eggert.dyndns.org>
References: <ck4Qt-44e-51@gated-at.bofh.it>
Reply-To: 7eggert@gmx.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:42671 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757773AbZC0Jg0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Mar 2009 05:36:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Mention ATAPI. We could insert an essay about libata and ide-scsi etc but
> the failure case is someone enables it which is just fine so keep it
> simple.

What about:

> +++ b/drivers/scsi/Kconfig
> @@ -121,7 +121,7 @@ config BLK_DEV_SR
>  tristate "SCSI CDROM support"

"CDROM support (except for old IDE and legacy drivers)"?

