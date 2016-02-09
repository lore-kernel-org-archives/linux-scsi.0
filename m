From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] scsi: fdomain: add missing CONFIG_ to PCMCIA
Date: Tue, 9 Feb 2016 23:25:10 +0000
Message-ID: <20160209232510.0c38ff77@lxorguk.ukuu.org.uk>
References: <1455056209-1696-1-git-send-email-yang.shi@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:32900 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914AbcBIXZc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Feb 2016 18:25:32 -0500
In-Reply-To: <1455056209-1696-1-git-send-email-yang.shi@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yang Shi <yang.shi@linaro.org>
Cc: JBottomley@odin.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linaro-kernel@lists.linaro.org

On Tue,  9 Feb 2016 14:16:49 -0800
Yang Shi <yang.shi@linaro.org> wrote:

> There are some "#ifdef PCMCIA" in the driver code, but all of them missed
> CONFIG_ prefix. Correct PCMCIA to CONFIG_PCMCIA.
> 
> Signed-off-by: Yang Shi <yang.shi@linaro.org>

NAK. This breaks the driver completely


Read drivers/scsi/pcmcia/fdomain*

Alan
