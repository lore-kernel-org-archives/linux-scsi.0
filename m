From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] cciss: Fix warnings during compilation under 32bit
	environment
Date: Thu, 19 Apr 2007 11:18:54 -0400
Message-ID: <1176995934.31764.7.camel@mulgrave.il.steeleye.com>
References: <6.0.0.20.2.20070418160231.043f23c8@172.19.0.2>
	 <226E1C65E4F6164E8EA5FD3CC913AE8CF461DE@G3W0639.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:41389 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766812AbXDSPTb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Apr 2007 11:19:31 -0400
In-Reply-To: <226E1C65E4F6164E8EA5FD3CC913AE8CF461DE@G3W0639.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, akpm@linux-foundation.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "Cameron, Steve" <steve.cameron@hp.com>

On Thu, 2007-04-19 at 15:09 +0000, Miller, Mike (OS Dev) wrote:
> Nak. You still haven't told where you saw these warnings. What compiler
> are you using? I do not see these in my 32-bit environment.

I think it's seen with CONFIG_LBD=n on 32 bits

In that configuration, sector_t is a u32 (it's u64 even on 32 bits with
CONFIG_LBD=y).  The proposed code change is a simple cut and paste from
the sd driver.

James


