From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [SCSI] sd: Ensure we correctly disable devices with unknown protection type
Date: Thu, 07 Feb 2013 14:24:33 -0500
Message-ID: <yq1bobwrkpa.fsf@sermon.lab.mkp.net>
References: <20120926082648.GA6721@elgon.mountain>
	<yq1txuk9ojz.fsf@sermon.lab.mkp.net> <20130206192903.GW4989@mwanda>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48802 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161002Ab3BGTYX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2013 14:24:23 -0500
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with ESMTP id r17JOLmU032304
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 7 Feb 2013 19:24:22 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id r17JOLr3017162
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 7 Feb 2013 19:24:21 GMT
Received: from abhmt101.oracle.com (abhmt101.oracle.com [141.146.116.53])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id r17JOLPU002807
	for <linux-scsi@vger.kernel.org>; Thu, 7 Feb 2013 13:24:21 -0600
In-Reply-To: <20130206192903.GW4989@mwanda> (Dan Carpenter's message of "Wed,
	6 Feb 2013 22:29:03 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Dan" == Dan Carpenter <dan.carpenter@oracle.com> writes:

Dan> This patch wasn't applied.

Nope, but it hasn't been forgotten. I have it in my resubmit queue with
a couple of other stable fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
