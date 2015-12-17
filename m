From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Note to driver maintainers
Date: Wed, 16 Dec 2015 19:32:28 -0500
Message-ID: <yq1h9jhud7n.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23746 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934255AbbLQAcb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2015 19:32:31 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id tBH0WUh3031570
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 17 Dec 2015 00:32:30 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by aserv0021.oracle.com (8.13.8/8.13.8) with ESMTP id tBH0WU7u007111
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Thu, 17 Dec 2015 00:32:30 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id tBH0WUkN015366
	for <linux-scsi@vger.kernel.org>; Thu, 17 Dec 2015 00:32:30 GMT
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


When somebody posts a patch to a piece of code you maintain it is your
responsibility to respond to it. That's what being a maintainer means.

There are a ton of trivial/Coccinelle fixes posted that nobody has done
anything about. I'm not talking about spelling fixes or whitespace
churn. Many of these patches look valid to me. There are also a few
non-trivial patches that have gotten no attention from the relevant
driver maintainers.

People such as Hannes, Johannes, Tomas and Christoph are reviewing
*your* submissions, providing the mandatory impartial review tag that
permits your patches to go into the main tree.

You can not rely on these people also taking on the burden of reviewing
third party changes to your code. That really is your job as the driver
maintainer. Every patch that touches code that you own demands a
response from you. Every. Single. Patch.

We review your changes. You have to review everybody else's.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
