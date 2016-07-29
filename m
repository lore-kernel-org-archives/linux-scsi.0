From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] ses: Fix racy cleanup of /sys in remove_dev()
Date: Thu, 28 Jul 2016 21:23:26 -0400
Message-ID: <yq1popx2q5t.fsf@sermon.lab.mkp.net>
References: <4912ec551a8ec01181cc3e7ad1e01d3d36758810.1463170976.git.calvinowens@fb.com>
	<5750B821.7010600@fb.com>
	<20160615202416.GA52103@calvinowens-mba.dhcp.thefacebook.com>
	<617c5fc1-ecc5-c825-ecb9-eeae2b637dfd@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38288 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbcG2BXg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2016 21:23:36 -0400
In-Reply-To: <617c5fc1-ecc5-c825-ecb9-eeae2b637dfd@fb.com> (Calvin Owens's
	message of "Wed, 27 Jul 2016 18:04:12 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Calvin Owens <calvinowens@fb.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Calvin" == Calvin Owens <calvinowens@fb.com> writes:

>> Any thoughts? Squinting at this more it still seems racy, but a
>> narrow race is surely better than just blatantly freeing everything
>> while the file is still exposed in /sys? Is there a better way you'd
>> prefer I accomplish this?
>> 
>> (I have boxes that OOPS all the time from monitoring code reading the
>> /sys files, with this patch I haven't seen a single one.)

Calvin> Ping? Thoughts, comments?

James: This is your puppy...

-- 
Martin K. Petersen	Oracle Linux Engineering
