From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [patch] qla4xxx: remove some bogus casts
Date: Mon, 17 Aug 2015 21:45:45 -0700
Message-ID: <55D2B879.7040906@sandisk.com>
References: <20150817143647.GA23820@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0092.outbound.protection.outlook.com ([207.46.100.92]:52352
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751062AbbHREpx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Aug 2015 00:45:53 -0400
In-Reply-To: <20150817143647.GA23820@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, QLogic-Storage-Upstream@qlogic.com, Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On 08/17/2015 07:36 AM, Dan Carpenter wrote:
> These casts are wrong and unnecessary.  They annoy static checkers
> because they imply we are planning to write sizeof(long) bytes to a
> sizeof(u32) buffer which would corrupt memory.

Hello Dan,

Can you verify whether that patch is still needed after having applied 
the patch series I posted in July (and that was acknowledged by QLogic): 
http://thread.gmane.org/gmane.linux.scsi/103135 ?

Thanks,

Bart.
