From: Siim Vahtre <siim@xf.ee>
Subject: Re: sequential I/O on SSD disk varies from 20 to 300 MBytes/s every
 week
Date: Mon, 2 Feb 2015 16:08:53 +0200 (EET)
Message-ID: <alpine.DEB.2.00.1502021600380.23745@q.xf.ee>
References: <alpine.DEB.2.00.1502021427020.2997@q.xf.ee> <CAOHikRBjOuUMdeyKDx0=+6YPKNrhZNquukAfdv-qMxYGFdX34Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from q.xf.ee ([89.221.70.14]:60801 "EHLO q.xf.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206AbbBBOJD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Feb 2015 09:09:03 -0500
In-Reply-To: <CAOHikRBjOuUMdeyKDx0=+6YPKNrhZNquukAfdv-qMxYGFdX34Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>

> Please check whether write cache is enabled in the drive
> also check whether NCQ is enabled or not.

About caches please note quote from my e-mail below. Changing NCQ 
enabled/disabled had no effect either.

>> 6) It is not a caching issue (controller/disk caches were off during 
>> testing, but even putting them on had minor impact on the results)
