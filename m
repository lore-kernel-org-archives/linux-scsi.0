From: Andi Kleen <ak@muc.de>
Subject: Re: [BK PATCH] essential SCSI fixes for 2.6.5-rc2
Date: Sun, 21 Mar 2004 05:36:28 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m31xnmlstv.fsf@averell.firstfloor.org>
References: <1079793048.1778.6.camel@mulgrave>
	<m3u10jr93e.fsf@averell.firstfloor.org>
	<1079796067.1755.18.camel@mulgrave>
	<000801c40f05$0daa3c50$231015ac@ericmoore>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zero.aec.at ([193.170.194.10]:54535 "EHLO zero.aec.at")
	by vger.kernel.org with ESMTP id S263613AbUCUGuo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Mar 2004 01:50:44 -0500
In-Reply-To: <000801c40f05$0daa3c50$231015ac@ericmoore> (Eric Dean Moore's
 message of "Sat, 20 Mar 2004 22:26:23 -0700")
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org

"Moore, Eric Dean" <emoore@lsil.com> writes:

> I will be consolidating the three allocations. I have started this work last
> Friday,
> and should be done early next week.

You could just use a dma pool. It was exactly done for situations like
this.

-Andi

