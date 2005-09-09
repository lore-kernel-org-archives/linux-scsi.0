From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 2.6.13 1/20] aic94xx: Makefile
Date: Fri, 09 Sep 2005 16:12:17 -0400
Message-ID: <4321ECA1.9050702@adaptec.com>
References: <4321E335.5010805@adaptec.com> <20050909201834.GA24521@mipter.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:33487 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1030444AbVIIUMX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2005 16:12:23 -0400
In-Reply-To: <20050909201834.GA24521@mipter.zuzino.mipt.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 09/09/05 16:18, Alexey Dobriyan wrote:
> On Fri, Sep 09, 2005 at 03:32:05PM -0400, Luben Tuikov wrote:
> 
>>--- linux-2.6.13-orig/drivers/scsi/aic94xx/Makefile
>>+++ linux-2.6.13/drivers/scsi/aic94xx/Makefile
> 
> 
>>+CHECK = sparse -Wbitwise
> 
> 
> 	make C=1 CHECK="sparse -Wbitwise"
> or
> 	make C=1
> 
> 
>>+clean-files += *~
> 
> 
> Don't override what other people want.

Ok, will do.

	Luben

