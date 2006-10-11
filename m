From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [2.6 patch] drivers/scsi/dpt_i2o.c: remove dead code
Date: Wed, 11 Oct 2006 18:45:54 +0100
Message-ID: <1160588754.16513.53.camel@localhost.localdomain>
References: <20061008231627.GO6755@stusta.de>
	 <1160578300.16513.15.camel@localhost.localdomain>
	 <20061011145222.GL721@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57282 "EHLO
	lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S1161087AbWJKRVf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Oct 2006 13:21:35 -0400
In-Reply-To: <20061011145222.GL721@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

> I don't see the point of the suggested place for the pci_dev_put()
> since pci_dev_get() has never been executed in this case, or do I miss 
> anything?

Correct, thats what I get for being away and reading 4000 emails when I
get back

Alan

