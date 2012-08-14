From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH 0/2] Fix the qla2xxx loopback selftests
Date: Tue, 14 Aug 2012 17:15:22 -0400
Message-ID: <alpine.WNT.2.00.1208141711460.172@N5102REMCQXM4BS.qlogic.org>
References: <502a736f.21d4320a.4e09.44cf@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [216.32.181.182] ([216.32.181.182]:58845 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756120Ab2HNVQm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Aug 2012 17:16:42 -0400
In-Reply-To: <502a736f.21d4320a.4e09.44cf@mx.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "steve@purestorage.com" <steve@purestorage.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>



On Tue, 14 Aug 2012, steve@purestorage.com wrote:

> From: Steve Hodgson <steve@purestorage.com>
>
> A few months ago our 2.6.39 based kernel started crashing almost 100%
> of the time when running the selftests, after seeminly unrelated kernel
> changes. In the end it was traced down to this use after free.
>
> Whilst here fix an error path memory leak.
>
> Thanks,
>
> Steve
>
> Steve Hodgson (2):
>  qla2xxx: Fix use after free in qla2x000_process_loopback.
>  qla2xxx: Free rsp_data even on error in qla2x00_process_loopback()
>
> drivers/scsi/qla2xxx/qla_bsg.c |   17 +++++++++--------
> 1 file changed, 9 insertions(+), 8 deletions(-)
>
>

Hi Steve, thanks for the patches. We'll look into them and let you know if
there is anything extra needed.

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

