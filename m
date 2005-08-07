From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: As of 2.6.13-rc1 Fusion-MPT very slow
Date: Sun, 07 Aug 2005 09:29:37 -0500
Message-ID: <1123424977.5020.4.camel@mulgrave>
References: <91888D455306F94EBD4D168954A9457C035CB64A@nacos172.co.lsil.com>
	 <Pine.LNX.4.61.0508011537250.23481@praktifix.dwd.de>
	 <1123350790.5092.2.camel@mulgrave>
	 <Pine.LNX.4.61.0508062058200.27998@praktifix.dwd.de>
	 <1123366064.5102.3.camel@mulgrave>
	 <Pine.LNX.4.61.0508070540560.12234@praktifix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:34016 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751847AbVHGOaI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 7 Aug 2005 10:30:08 -0400
In-Reply-To: <Pine.LNX.4.61.0508070540560.12234@praktifix.dwd.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: "Moore, Eric Dean" <Eric.Moore@lsil.com>, Andrew Morton <akpm@osdl.org>, linux-kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2005-08-07 at 05:59 +0000, Holger Kiehl wrote:
> Thanks, removing those it compiles fine. This patch also solves my problem,
> here the output of dmesg:

Well ... the transport class was supposed to help diagnose the problem
rather than fix it.

However, what it shows is that the original problem is in the fusion
internal domain validation somewhere, but that we still don't know
where...

James


