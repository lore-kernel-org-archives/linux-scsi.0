From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] qla2xyz: use NULL instead of 0
Date: Mon, 27 Nov 2006 09:37:20 -0800
Message-ID: <20061127173720.GD21083@andrew-vasquezs-computer.local>
References: <20061127093542.1dd8c0a8.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:8138 "EHLO
	avexch1.qlogic.com") by vger.kernel.org with ESMTP id S1756025AbWK0RhV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Nov 2006 12:37:21 -0500
Content-Disposition: inline
In-Reply-To: <20061127093542.1dd8c0a8.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, linux-driver@qlogic.com, jejb <james.bottomley@steeleye.com>

On Mon, 27 Nov 2006, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Use NULL instead of 0 for pointers (sparse warning):
> drivers/scsi/qla2xxx/qla_attr.c:393:4: warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
