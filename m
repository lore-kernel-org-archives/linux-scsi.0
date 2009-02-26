From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RFC: Transport identifier
Date: Thu, 26 Feb 2009 15:22:23 -0500
Message-ID: <yq1tz6heyo0.fsf@sermon.lab.mkp.net>
References: <yq1iqmxg6o4.fsf@sermon.lab.mkp.net>
	<646765f40902252054t3def25e4j73ccd0192e0be51e@mail.gmail.com>
	<20090226053221.GB1145@ca-server1.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:25356 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029AbZBZUWg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Feb 2009 15:22:36 -0500
Received: from rgminet15.oracle.com (rcsinet15.oracle.com [148.87.113.117])
	by acsinet11.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n1QKN0Q0022844
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2009 20:23:02 GMT
Received: from acsmt707.oracle.com (acsmt707.oracle.com [141.146.40.85])
	by rgminet15.oracle.com (Switch-3.3.1/Switch-3.3.1) with ESMTP id n1QKMTi6006219
	for <linux-scsi@vger.kernel.org>; Thu, 26 Feb 2009 20:22:30 GMT
In-Reply-To: <20090226053221.GB1145@ca-server1.us.oracle.com> (Joel Becker's message of "Wed\, 25 Feb 2009 21\:32\:21 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joel.Becker@oracle.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Joel" == Joel Becker <Joel.Becker@oracle.com> writes:

Joel> I like doing this:

Joel> static const char * const transport_names[] = {
Joel> 	[SCSI_TRANSPORT_SPI] = "spi", ...
Joel> };

Joel> Joel

Oh, slick!

-- 
Martin K. Petersen	Oracle Linux Engineering
