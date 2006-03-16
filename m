From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 6/6] scsi tgt: Makefile and Kconfig changes
Date: Thu, 16 Mar 2006 09:00:17 +0900
Message-ID: <20060316090017H.fujita.tomonori@lab.ntt.co.jp>
References: <1140119627.20193.55.camel@max>
	<44173C6C.1050003@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:20952 "EHLO
	tama5.ecl.ntt.co.jp") by vger.kernel.org with ESMTP id S932549AbWCPAA2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Mar 2006 19:00:28 -0500
In-Reply-To: <44173C6C.1050003@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: j-nomura@ce.jp.nec.com
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 6/6] scsi tgt: Makefile and Kconfig changes
Date: Tue, 14 Mar 2006 16:58:04 -0500

> scsi_tgt_if.c depends on CONFIG_NET for using netlink.
> So it would be nice if the Kconfig entry checks it.

Yep. Thanks.
