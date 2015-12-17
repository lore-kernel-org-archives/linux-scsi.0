From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 16/17] lpfc: Use kzalloc instead of kmalloc
Date: Thu, 17 Dec 2015 23:58:58 +0100
Message-ID: <20151217235858.00004089@localhost>
References: <5671efc7.97bycJ6w84wBFCRH%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52518 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbbLQW7A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Dec 2015 17:59:00 -0500
In-Reply-To: <5671efc7.97bycJ6w84wBFCRH%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

James Smart wrote:
> From:	Punit Vara <punitvara@gmail.com>
> 
> This patch is to the lpfc_els.c which resolves following warning
> reported by coccicheck:
> 
> WARNING: kzalloc should be used for rdp_context, instead of
> kmalloc/memset
> 
> Signed-off-by: Punit Vara <punitvara@gmail.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>

You missed the two already available positive reviews [1][2].

Anyway,

Reviewed-by: Sebastian Herbszt <herbszt@gmx.de>

[1] http://marc.info/?l=linux-scsi&m=144574360607327&w=2
[2] http://marc.info/?l=linux-scsi&m=144823385015994&w=2
