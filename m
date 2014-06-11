From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 linux-scsi-ml] linux-firmware: qla2xxx: Update
 ql2{4,5}00_fw.bin to version 7.03.00
Date: Wed, 11 Jun 2014 05:15:33 -0700
Message-ID: <20140611121533.GA8389@infradead.org>
References: <5396D747.9000107@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38741 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbaFKMPd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 08:15:33 -0400
Content-Disposition: inline
In-Reply-To: <5396D747.9000107@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Carnuccio <joe.carnuccio@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Qlogic internal list <linux-driver@qlogic.com>, Linux Firmware Maintainers <linux-firmware@kernel.org>

On Tue, Jun 10, 2014 at 12:00:39PM +0200, Xose Vazquez Perez wrote:
> resent to linux-scsi-ml, without the binary blob(244K).
> 
> Firmwares were taken from http://ldriver.qlogic.com/firmware/

Looks good, while there's nothing really to review for a firmware blob
update, can you get me a review or second signoff instead of all the Ccs?

Does this need to go with the updates we merged for 3.16, or can it wait
for 3.17?

