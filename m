From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Build fallout from scsi merge...
Date: Mon, 28 Jul 2008 06:55:32 -0700
Message-ID: <20080728135532.GA3358@plap4-2.qlogic.org>
References: <20080727.170415.12257647.davem@davemloft.net> <20080728115954E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:33775 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbYG1Nzd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jul 2008 09:55:33 -0400
Content-Disposition: inline
In-Reply-To: <20080728115954E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: davem@davemloft.net, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008, FUJITA Tomonori wrote:

> From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Subject: [PATCH] qla2xxx: fix msleep compile error
> 
> drivers/scsi/qla2xxx/qla_attr.c: In function 'qla24xx_vport_delete':
> drivers/scsi/qla2xxx/qla_attr.c:1184: error: implicit declaration of function 'msleep'
> make[3]: *** [drivers/scsi/qla2xxx/qla_attr.o] Error 1
> make[3]: *** Waiting for unfinished jobs....
> 
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
> Cc: James.Bottomley@HansenPartnership.com

Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

Tomo, thank you.
