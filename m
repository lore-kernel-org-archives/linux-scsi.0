From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH]sd: Don't treat succeeded SYNC as error
Date: Mon, 25 Apr 2016 13:28:31 -0700
Message-ID: <571E7DEF.2090005@sandisk.com>
References: <CAMGffEnAYXdYNfN7aHZHLjnhxY2T2V6m4tPNi4eT4kDuarrYxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0061.outbound.protection.outlook.com ([207.46.100.61]:3528
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933428AbcDYU2f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2016 16:28:35 -0400
In-Reply-To: <CAMGffEnAYXdYNfN7aHZHLjnhxY2T2V6m4tPNi4eT4kDuarrYxQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, Christoph Hellwig <hch@infradead.org>, s.parschauer@gmx.de

On 04/25/2016 03:36 AM, Jinpu Wang wrote:
> We hit IO error on fsync, it turns out was because sd treat succeeded
> SYNC as error. From what I checked in SBC spec there is no indication
> we should fail IO in this case, so we create this patch.

Please follow the rules in Documentation/SubmittingPatches and submit 
patches inline. Regarding the patch itself: why is the switch(op) 
needed? Can it be left out? And regarding (sshdr.asc == 0x2a && 
sshdr.ascq == 0x09): which other unit attentions should cause SCSI 
commands to succeed instead of to fail?

Bart.
