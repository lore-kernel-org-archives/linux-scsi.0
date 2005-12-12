From: David.Egolf@Bull.com
Subject: Re: how to tell a WWN of FC HBA under linux
Date: Mon, 12 Dec 2005 13:54:10 -0700
Message-ID: <OF2D863805.981C8AEC-ON072570D5.0072572A-072570D5.0072D2CA@us-phx1.az05.bull.com>
References: <1134413431.10254.91.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailsrvr2.bull.com ([192.90.162.8]:42929 "EHLO
	mailsrvr2.bull.com") by vger.kernel.org with ESMTP id S1751224AbVLLUyT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Dec 2005 15:54:19 -0500
In-Reply-To: <1134413431.10254.91.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mingz@ele.uri.edu
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org

Ming,

With earlier releases of Kernel 2.6 we had to rely on the board driver to 
put this information in the proc file system.  We were using Emulex boards 
whose drivers performed this service.

In later versions of 2.6, some entity has been placing this information in 
the sys directory.  We are using a Red Hat derivative, but we think that 
this is independent of the distribution.

David Egolf

linux-scsi-owner@vger.kernel.org wrote on 12/12/2005 11:50:31 AM:

> Hi folks
> 
> I know it is possible that tell the WWN during post. But is it possible
> to tell under linux after system boots?
> 
> Thanks!
> 
> Ming
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

