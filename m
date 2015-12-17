From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 15/17] lpfc: Delete unnecessary checks before the
 function call "mempool_destroy"
Date: Thu, 17 Dec 2015 23:35:50 +0100
Message-ID: <20151217233550.0000241b@localhost>
References: <5671efc6.ZwH5WdfbRkt48aQV%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:64579 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932946AbbLQWfz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 17:35:55 -0500
In-Reply-To: <5671efc6.ZwH5WdfbRkt48aQV%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> 
> The mempool_destroy() function tests whether its argument is NULL
> and then returns immediately. Thus the test around the calls is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> Signed-off-by: James Smart <james.smart@avagotech.com>

Reviewed-by: Sebastian Herbszt <herbszt@gmx.de>
