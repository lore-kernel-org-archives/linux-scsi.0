From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: 2.5.70-mm2: NCR_D700.c doesn't compile
Date: 29 May 2003 17:01:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1054242118.1819.465.camel@mulgrave>
References: <20030529012914.2c315dad.akpm@digeo.com>
	<20030529205742.GI5643@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:31495 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262776AbTE2Uv5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 May 2003 16:51:57 -0400
In-Reply-To: <20030529205742.GI5643@fs.tum.de>
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@fs.tum.de>
Cc: Andrew Morton <akpm@digeo.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2003-05-29 at 16:57, Adrian Bunk wrote:
> It seems the following compile error comes from Linus' tree:

Yes, I already have the fix (which is to add the correct argument to the
function).

James


