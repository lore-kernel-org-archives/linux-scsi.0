From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: Infinite retries reading the partition table
Date: Wed, 29 Nov 2006 17:53:25 -0800 (PST)
Message-ID: <994367.96477.qm@web31806.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31806.mail.mud.yahoo.com ([68.142.207.69]:62815 "HELO
	web31806.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S967816AbWK3Bx0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Nov 2006 20:53:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

--- Luben Tuikov <ltuikov@yahoo.com> wrote:

> Suppose reading sector 0 always reports an error,
> sense key HARDWARE ERROR.
> 
> What I'm observing is that the request to read sector 0,
> reading partition information, is retried forever, ad infinitum.
> 
> Does anyone have a patch to resolve this? (2.6.19-rc6)

Actually the device sends SK: MEDIUM ERROR, ASC: UNRECOVERED READ ERR,
but SCSI Core seems to retry reading the partition table (sector 0)
forever.

Anyone seen this and/or has a patch in their tree for it?

   Luben
P.S.  This is fairly straightforward to inject/test.

