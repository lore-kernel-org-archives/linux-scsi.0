From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 1/6] SCSI: esas2r: smatch - Use biwise rather than
 logical AND for checking if any bit set
Date: Fri, 6 Sep 2013 18:15:22 +0000
Message-ID: <1378491321.2063.26.camel@dabdike.int.hansenpartnership.com>
References: <1377806144-4902-1-git-send-email-bgrove@attotech.com>
	 <1377806144-4902-2-git-send-email-bgrove@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:43223 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3IFSPX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 14:15:23 -0400
In-Reply-To: <1377806144-4902-2-git-send-email-bgrove@attotech.com>
Content-Language: en-US
Content-ID: <17BE6DB006FF084E8708F806F71AB031@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bradley Grove <bgrove@attotech.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "jseba@attotech.com" <jseba@attotech.com>, "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>, "fengguang.wu@intel.com" <fengguang.wu@intel.com>

On Thu, 2013-08-29 at 15:55 -0400, Bradley Grove wrote:
> Signed-off-by: Bradley Grove <bgrove@attotech.com>

This additional SCSI: in the subject is unnecessary and just causes me
extra work to remove it.

There should be a Reported-by: before the signoff indicating whoever you
got the report from (it's about the only recognition we give to the
static checker people, so it's polite to include it).

I fixed up this current series.

James



