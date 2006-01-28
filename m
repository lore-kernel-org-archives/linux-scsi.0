From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 2.6.15-rc7-git3 1/3] sata_promise: add correct read/write
 of hotplug registers for SATAII devices
Date: Sat, 28 Jan 2006 12:39:48 -0500
Message-ID: <43DBAC64.1070902@pobox.com>
References: <355e5e5e0512291523h508fe0c8j459a9377d52d5529@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:36041 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1751489AbWA1RkA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Jan 2006 12:40:00 -0500
In-Reply-To: <355e5e5e0512291523h508fe0c8j459a9377d52d5529@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lukasz Kosewski <lkosewsk@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Lukasz Kosewski wrote:
> This patch adds support for correctly masking out and knowing about
> hotplug events on Promise SATAII150 Tx4/Tx2 Plus controllers.
> 
> Signed-off-by:  Luke Kosewski <lkosewsk@gmail.com>

applied


