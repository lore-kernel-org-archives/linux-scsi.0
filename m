From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 2.6.13 1/20] aic94xx: Makefile
Date: Sat, 10 Sep 2005 00:18:34 +0400
Message-ID: <20050909201834.GA24521@mipter.zuzino.mipt.ru>
References: <4321E335.5010805@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wproxy.gmail.com ([64.233.184.206]:35309 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S1030434AbVIIUIv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2005 16:08:51 -0400
Received: by wproxy.gmail.com with SMTP id i2so1463586wra
        for <linux-scsi@vger.kernel.org>; Fri, 09 Sep 2005 13:08:43 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4321E335.5010805@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Sep 09, 2005 at 03:32:05PM -0400, Luben Tuikov wrote:
> --- linux-2.6.13-orig/drivers/scsi/aic94xx/Makefile
> +++ linux-2.6.13/drivers/scsi/aic94xx/Makefile

> +CHECK = sparse -Wbitwise

	make C=1 CHECK="sparse -Wbitwise"
or
	make C=1

> +clean-files += *~

Don't override what other people want.

