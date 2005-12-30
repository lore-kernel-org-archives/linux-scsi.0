From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2.6.15-rc7-git3 1/3] sata_promise: add correct
	read/write of hotplug registers for SATAII devices
Date: Fri, 30 Dec 2005 15:09:07 +0000
Message-ID: <1135955347.28365.5.camel@localhost.localdomain>
References: <355e5e5e0512291523h508fe0c8j459a9377d52d5529@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [81.2.110.250] ([81.2.110.250]:190 "EHLO lxorguk.ukuu.org.uk")
	by vger.kernel.org with ESMTP id S1750827AbVL3PHs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Dec 2005 10:07:48 -0500
In-Reply-To: <355e5e5e0512291523h508fe0c8j459a9377d52d5529@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lukasz Kosewski <lkosewsk@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Iau, 2005-12-29 at 18:23 -0500, Lukasz Kosewski wrote:
> This patch adds support for correctly masking out and knowing about
> hotplug events on Promise SATAII150 Tx4/Tx2 Plus controllers.

Please call the core API ata_ not sata_. Many PATA controllers support
device hotplug or warmplug. (warmplug -> tell the OS first then unplug
then plug then tell the OS)

Alan
