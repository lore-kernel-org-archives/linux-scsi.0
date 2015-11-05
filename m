From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] ses: tighten range checks in ses_intf_add()
Date: Fri, 6 Nov 2015 00:52:55 +0300
Message-ID: <20151105215255.GN7289@mwanda>
References: <----An------QYmAn$10b010ca-f710-44aa-8ea3-3b65a3c21286@alibaba-inc.com>
 <20151019134820.GA28752@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26023 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbbKEVxT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2015 16:53:19 -0500
Content-Disposition: inline
In-Reply-To: <20151019134820.GA28752@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, =?utf-8?B?56iL5ZCbKOaIkOa3vCk=?= <chengmiao.cj@alibaba-inc.com>, throber3 <throber3@gmail.com>, security@kernel.org

James, could you take a look at this?  My patch was really incomplete
and even the bits that I wrote were buggy...  :/  This might be easier
for someone who is familiar with the code and can say what the expected
ranges are etc.

regards,
dan carpenter

