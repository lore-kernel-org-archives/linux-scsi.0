From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Question on qla2xxx Kconfig update in 2.6.2
Date: 05 Feb 2004 11:54:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1076000088.1756.25.camel@mulgrave>
References: <20040205163722.GA2498@beaverton.ibm.com>
	<1075999192.1756.23.camel@mulgrave>
	<20040205165807.GB2498@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:20707 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266302AbUBEQyv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Feb 2004 11:54:51 -0500
In-Reply-To: <20040205165807.GB2498@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>

On Thu, 2004-02-05 at 11:58, Mike Anderson wrote:
> Should we fix it the other way around (i.e., have qla2xxx Kconfig
> use SCSI_QLA2XXX) to be consistent with other Kconfig users. I see only
> one other in the .config file that I am using that has a _CONFIG postfix.

Well, least line of resistance when things don't work.

But I agree, removing the _CONFIG in qla2xxx/Kconfig does look better.

James


