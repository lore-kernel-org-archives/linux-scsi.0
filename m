From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Adaptect 9405w: What is the best solution?
Date: Thu, 11 Jan 2007 12:08:23 -0800
Message-ID: <45A69937.8030400@us.ibm.com>
References: <45A6195E.7020103@scanventure.no> <45A6570C.3090308@torque.net> <45A6906D.3040805@us.ibm.com> <45A694A1.6010400@scanventure.no>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:58743 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbXAKUIe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jan 2007 15:08:34 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BK8Pm2017979
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 15:08:25 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BK8PeQ512198
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 13:08:25 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BK8OXX029606
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 13:08:25 -0700
In-Reply-To: <45A694A1.6010400@scanventure.no>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tarjei Huse <tarjei@scanventure.no>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org, "Wu, Gilbert" <Gilbert_Wu@adaptec.com>, "Chim, Ed" <ed_chim@adaptec.com>, Alexis Bruemmer <alexisb@us.ibm.com>

Tarjei Huse wrote:

> Ok, I haven't tested a git tree yet, but what you're saying is that I
> should download just this git tree and use it, right?

I suppose you could do that with some patch massaging, though at the
moment the patches are based off 2.6.20-rc4 + scsi-misc + scsi-rc-fixes
+ aic94xx-sas and will probably generate quite a bit of fuzz when
applied against anything else.

> http://www.kernel.org/git/?p=linux/kernel/git/jejb/aic94xx-sas-2.6.git;a=summary
> Or should I just download the the patches you mention and

...and?  I think your message got truncated?

> What patches? Are they related to the aic driver or are they related to
> other things you are testing? (i.e. do I run a risk by using them?

All of those patches fix problems seen while testing/beating/exercising
the aic94xx driver.

> Also, when will this work land in the mainline kernel tree?

Hopefully sooner than later.

--D
