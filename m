From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 5/8] mptfusion: command line parameters
Date: Fri, 19 Nov 2004 19:07:58 +0000
Message-ID: <20041119190758.GA7936@infradead.org>
References: <91888D455306F94EBD4D168954A9457C54677C@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:30472 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261537AbUKSTID (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 14:08:03 -0500
Content-Disposition: inline
In-Reply-To: <91888D455306F94EBD4D168954A9457C54677C@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

-/* Set string for command line args from insmod */
 #ifdef MODULE
-char *mptscsih = NULL;
-module_param(mptscsih, charp, 0);
+static int dv = MPTSCSIH_DOMAIN_VALIDATION;
+module_param(dv, int, 0);
+MODULE_PARM_DESC(dv, "DV Algorithm: enhanced = 1, basic = 0 (default=MPTSCSIH_DOMAIN_VALIDATION=1)");

please remove the ifdef MODULE - module_param is fine for builtin drivers
aswell, then you can use mptscsih.<option>=<value>

