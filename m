From: Miquel van Smoorenburg <mikevs@xs4all.net>
Subject: [PATCH 0/4] dpt_i2o: 64 bit support (take 5)
Date: Fri, 2 May 2008 01:02:15 +0200
Message-ID: <20080501230211.GA19796@xs4all.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3644 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933696AbYEAXKP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 19:10:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, miquels@cistron.nl, Rolf Eike Beer <eike-kernel@sf-tec.de>, James Bottomley <James.Bottomley@HansenPartnership.com>

[PATCH 0/4] dpt_i2o: 64 bit support (take 5)

These patches update the dpt_i2o driver to work on 64-bit platforms
like x86_64.

This code is based in part on the unofficial adaptec 64-bit
dpt_i2o driver update that I got from Mark Salyzyn at Adaptec.

The driver can use some additional cleanups but that wasn't the
focus for this patch series.

Thanks to Rolf Eike Beer and James Bottomley for reviewing the
previous patches and offering constructive criticism. I tried
to take all your comments into account.

Please consider this for 2.6.26.

[PATCH 1/4] dpt_i2o: use standard __init / __exit code
[PATCH 2/4] dpt_i2o: move from virt_to_bus/bus_to_virt to dma_alloc_coherent
[PATCH 3/4] dpt_i2o: 64 bit support
[PATCH 4/4] dpt_i2o: sysfs code

Mike.
