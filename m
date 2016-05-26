From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: Converting ipr to use ata_port_operations->error_handler
Date: Thu, 26 May 2016 09:12:32 -0500
Message-ID: <57470450.3070000@linux.vnet.ibm.com>
References: <CAOS58YO65A8TpH22tEdM4SUcn8ncpY1f_YFMzomCN09OvhoRaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:55089 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721AbcEZOMj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 May 2016 10:12:39 -0400
Received: from localhost
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 26 May 2016 08:12:36 -0600
In-Reply-To: <CAOS58YO65A8TpH22tEdM4SUcn8ncpY1f_YFMzomCN09OvhoRaQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>

On 05/25/2016 02:32 PM, Tejun Heo wrote:
> Hello, Brian.
> 
> So, of all the ata drivers, ipr seems to be the only driver which
> doesn't implement ata_port_opeations->error_handler and thus depends
> on the old error handling path. I'm wondering whether it'd be possible
> to convert ipr to implement ->error_handler and drop the old path.
> Would that be difficult?

Last time I looked at that there were a number of challenges in doing that,
but let me take another look and see if we can figure out a way to do that.

Thanks,

Brian


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

