From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [2.6 patch] SCSI: cleanups
Date: Mon, 28 Mar 2005 10:00:17 -0600
Message-ID: <1112025617.5531.16.camel@mulgrave>
References: <20050327202139.GQ4285@stusta.de>
	 <1112023305.5531.2.camel@mulgrave>
	 <1112023757.6003.27.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:15057 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261908AbVC1QB1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Mar 2005 11:01:27 -0500
In-Reply-To: <1112023757.6003.27.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Adrian Bunk <bunk@stusta.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Mon, 2005-03-28 at 17:29 +0200, Arjan van de Ven wrote:
> how about a CONFIG_SCSI_DRIVER_DEBUG ?

In principle, that's fine ... in practice does the few bytes saved by
this really justify adding yet another option?

James


