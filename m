From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 2/2] libata-scsi: avoid repeated calculation of number
 of TRIM ranges
Date: Tue, 12 Jul 2016 16:38:12 -0400
Message-ID: <20160712203812.GE10377@htj.duckdns.org>
References: <844c07e66ad6d410029d80e6b32e8f1480fa9f47.1468354842.git.tom.ty89@gmail.com>
 <7f727a9fd877b2c16cd8799e1da8be71f5b8eaf3.1468354842.git.tom.ty89@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:35844 "EHLO
	mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbcGLUiX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2016 16:38:23 -0400
Content-Disposition: inline
In-Reply-To: <7f727a9fd877b2c16cd8799e1da8be71f5b8eaf3.1468354842.git.tom.ty89@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tom.ty89@gmail.com
Cc: martin.petersen@oracle.com, sergei.shtylyov@cogentembedded.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Jul 13, 2016 at 04:31:23AM +0800, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
> 
> Currently libata statically allows only 1-block (512-byte) payload
> for each TRIM command. Each payload can carry 64 TRIM ranges since
> each range requires 8 bytes.
> 
> It is silly to keep doing the calculation (512 / 8) in different
> places. Hence, define the new ATA_MAX_TRIM_RNUM for the result.
> 
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>

Applied 1-2 to libata/for-4.8.

Thanks.

-- 
tejun
