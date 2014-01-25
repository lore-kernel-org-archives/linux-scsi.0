From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: status of drivers/scsi/scsi_tgt_lib.c
Date: Sat, 25 Jan 2014 12:48:32 +0900 (JST)
Message-ID: <20140125.124832.1568838937885770665.fujita.tomonori@lab.ntt.co.jp>
References: <20140124131525.GA30922@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:59428 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaAYDx5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jan 2014 22:53:57 -0500
In-Reply-To: <20140124131525.GA30922@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

Hey,

On Fri, 24 Jan 2014 05:15:25 -0800
Christoph Hellwig <hch@infradead.org> wrote:

> Do you know if either SRP or ibmvscsi are used regularly these days?
> Does tgtd userspace still support this interface?

It doesn't. I think that ibm pseries switched to virtual fc driver
from virtual srp long ago. Only very old pseries could use the
driver. I'm not sure there are any users of the driver. I guess that
you could try to remove the driver to see if someone would complain.
