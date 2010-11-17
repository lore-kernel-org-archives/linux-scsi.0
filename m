From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: lio-core-2.6.git updated to .37-rc2+
Date: Wed, 17 Nov 2010 12:58:14 -0800
Message-ID: <1290027494.31890.50.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:57279 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab0KQVDg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 16:03:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@suse.de>, Mike Anderson <andmike@linux.vnet.ibm.com>, Jeff Garzik <jeff@garzik.org>

Hi Folks,

This is just a friendly note that lio-core-2.6.git/lio-4.0 and master
have been updated to v2.6.37-rc2+ containing jgarzik's full host_lock
commit 3039f3ffcc5 (now in linus's tree) and andmike / jejb's:

[PATCH] Eliminate error handler overload of the SCSI serial number

I will be respinning a lock_less-LLDs-for-38-v2 series on top of
this code shortly.

Thanks!

--nab




