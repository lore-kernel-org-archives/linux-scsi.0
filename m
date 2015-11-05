From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] ses: tighten range checks in ses_intf_add()
Date: Thu, 05 Nov 2015 14:01:20 -0800
Message-ID: <1446760880.2211.31.camel@HansenPartnership.com>
References: <----An------QYmAn$10b010ca-f710-44aa-8ea3-3b65a3c21286@alibaba-inc.com>
	 <20151019134820.GA28752@mwanda> <20151105215255.GN7289@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33100 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274AbbKEWBW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2015 17:01:22 -0500
In-Reply-To: <20151105215255.GN7289@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org, =?UTF-8?Q?=E7=A8=8B=E5=90=9B=28=E6=88=90=E6=B7=BC=29?= <chengmiao.cj@alibaba-inc.com>, throber3 <throber3@gmail.com>, security@kernel.org

On Fri, 2015-11-06 at 00:52 +0300, Dan Carpenter wrote:
> James, could you take a look at this?  My patch was really incomplete
> and even the bits that I wrote were buggy...  :/  This might be easier
> for someone who is familiar with the code and can say what the expected
> ranges are etc.

Yes, I've got a couple of SES things to look into, but not until after
the merge window closes, probably.

James


