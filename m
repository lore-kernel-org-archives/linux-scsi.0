From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Fri, 12 Aug 2005 00:06:16 +0200
Message-ID: <42FBCBD8.7040707@s5r6.in-berlin.de>
References: <OF5B21133C.F5A53509-ON8825705A.005F65D9-8825705A.00611764@us.ibm.com>
Reply-To: linux-scsi@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:39913 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932405AbVHKWGh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 18:06:37 -0400
Received: from [192.168.0.41] ([62.180.98.151])
	(authenticated bits=0)
	by einhorn.in-berlin.de (8.12.10/8.12.10/Debian-4) with ESMTP id j7BM6RjF025446
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2005 00:06:31 +0200
In-Reply-To: <OF5B21133C.F5A53509-ON8825705A.005F65D9-8825705A.00611764@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Bryan Henderson wrote:
> Because removable devices exist, we do have to allow remove-single-device 
> of an in-use device in general,

Do we? I don't know of a use case of the add/remove-single-device user 
interface under Linux 2.6 as far as hotpluggable hardware is concerned.
-- 
Stefan Richter
-=====-=-=-= =--- -==--
http://arcgraph.de/sr/
