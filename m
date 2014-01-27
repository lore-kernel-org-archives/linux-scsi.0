From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: status of drivers/scsi/scsi_tgt_lib.c
Date: Tue, 28 Jan 2014 00:45:04 +0900 (JST)
Message-ID: <20140128.004504.1305564732068179852.fujita.tomonori@lab.ntt.co.jp>
References: <20140124131525.GA30922@infradead.org>
	<20140125.124832.1568838937885770665.fujita.tomonori@lab.ntt.co.jp>
	<20140127075038.GA18590@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:35935 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaA0Pua (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jan 2014 10:50:30 -0500
In-Reply-To: <20140127075038.GA18590@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Sun, 26 Jan 2014 23:50:38 -0800
Christoph Hellwig <hch@infradead.org> wrote:

>> > Do you know if either SRP or ibmvscsi are used regularly these days?
>> > Does tgtd userspace still support this interface?
>> 
>> It doesn't. I think that ibm pseries switched to virtual fc driver
>> from virtual srp long ago. Only very old pseries could use the
>> driver. I'm not sure there are any users of the driver. I guess that
>> you could try to remove the driver to see if someone would complain.
> 
> Should we try to throw in a deprecation warnings for this merge window
> and see if anyone cares, or go ahead and remove it entirely?

Either is fine by me.
