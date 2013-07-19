From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 1/2] qla2xxx: Fix sparse warnings in qlafx00_fxdisc_iocb
 function.
Date: Fri, 19 Jul 2013 14:44:03 +0000
Message-ID: <1374245042.2266.5.camel@dabdike>
References: <1373654871-29081-1-git-send-email-saurav.kashyap@qlogic.com>
	 <1373654871-29081-2-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:34210 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3GSOoF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Jul 2013 10:44:05 -0400
In-Reply-To: <1373654871-29081-2-git-send-email-saurav.kashyap@qlogic.com>
Content-Language: en-US
Content-ID: <874EE8E24CEAC147BE73CA9580B1EFF0@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: "giridhar.malavali@qlogic.com" <giridhar.malavali@qlogic.com>, "andrew.vasquez@qlogic.com" <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, 2013-07-12 at 14:47 -0400, Saurav Kashyap wrote:
> Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>

This does not fix a bug ... therefore it's not really -rc fixes
material.  In early -rc this rule can be relaxed a bit ... but what's
the reason to get this through the -rc tree?

James

