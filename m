From: Olaf Hering <olaf@aepfle.de>
Subject: Re: [PATCH] storvsc: use small sg_tablesize on x86
Date: Thu, 28 Jan 2016 07:48:23 +0100
Message-ID: <20160128064822.GA12884@aepfle.de>
References: <1441706801-15300-1-git-send-email-olaf@aepfle.de>
 <BY2PR0301MB16540206D42C1E00EC353D0EA04C0@BY2PR0301MB1654.namprd03.prod.outlook.com>
 <1443732718.6886.23.camel@HansenPartnership.com>
 <20151002171415.GA30430@gmail.com>
 <20160125083514.GA11991@gmail.com>
 <BY2PR0301MB1654E0BA47F3D2CC6D83BD64A0D90@BY2PR0301MB1654.namprd03.prod.outlook.com>
 <1453960859.2322.58.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.162]:11337 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbcA1Gs2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 01:48:28 -0500
Content-Disposition: inline
In-Reply-To: <1453960859.2322.58.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Jan 27, James Bottomley wrote:

> It's not really architecture independent, is it?  Just use the bit
> width config.

Again: which one? This driver is not for mips|powerpc|score|sh.

Olaf
