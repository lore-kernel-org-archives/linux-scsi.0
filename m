From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] arcmsr: Fix a potential data corruption issue
Date: Fri, 10 Jul 2015 12:25:52 +0300
Message-ID: <20150710092552.GV4341@mwanda>
References: <1436505490-9640-1-git-send-email-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41151 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838AbbGJJ0O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jul 2015 05:26:14 -0400
Content-Disposition: inline
In-Reply-To: <1436505490-9640-1-git-send-email-christophe.jaillet@wanadoo.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Fri, Jul 10, 2015 at 07:18:10AM +0200, Christophe JAILLET wrote:
> Resetting rqbuffer or wqbuffer must be done within a critial section
> in order to avoir potential data corruption.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---

I don't know the code well enough to say if it's necessary, but it seems
reasonable to me.

regards,
dan carpenter

