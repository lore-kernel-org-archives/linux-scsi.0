From: Arjan van de Ven <arjan@infradead.org>
Subject: RE: [PATCH] 2.6 aacraid: Add sysfs files for aacraid adapter
	information (re-diff)
Date: Mon, 23 May 2005 14:20:40 +0200
Message-ID: <1116850841.6280.24.camel@laptopd505.fenrus.org>
References: <60807403EABEB443939A5A7AA8A7458B0132B6EC@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:28139 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261319AbVEWMUt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2005 08:20:49 -0400
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B0132B6EC@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>


> I would be concerned about "kernel_version" confusion in the namespace
> of the /sys/ filesystem.

how about calling it firmware_kernel_version or hba_kernel_version?


