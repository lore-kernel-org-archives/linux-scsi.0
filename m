From: Siim Vahtre <siim@xf.ee>
Subject: Re: sequential I/O on SSD disk varies from 20 to 300 MBytes/s every
 week
Date: Wed, 4 Feb 2015 11:50:58 +0200 (EET)
Message-ID: <alpine.DEB.2.00.1502041138490.8618@q.xf.ee>
References: <alpine.DEB.2.00.1502021427020.2997@q.xf.ee> <CAOHikRBjOuUMdeyKDx0=+6YPKNrhZNquukAfdv-qMxYGFdX34Q@mail.gmail.com> <alpine.DEB.2.00.1502021600380.23745@q.xf.ee> <CAN7X1UkducENcF_+GuY7rY3q+qAhAp9H1HWMAXnFFtfTjX7Zrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from q.xf.ee ([89.221.70.14]:43655 "EHLO q.xf.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933616AbbBDJvD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Feb 2015 04:51:03 -0500
In-Reply-To: <CAN7X1UkducENcF_+GuY7rY3q+qAhAp9H1HWMAXnFFtfTjX7Zrw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Purush Gupta <purush.gupta@nutanix.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>

> Since you mentioned problem does not happen on Windows, what do you use 
> to emulate the workload (iometer ?)

CrystalDiskMark, HD Tune, ATTO Disk Benchmark

Tested for 2-3 hours, but got stable results. Directly afterwards booted 
Live CD with Linux and immediately got poor results.


> and did you see the same behaviour with other Kernel versions like 
> 2.6.32.

I did not test this, as this kernel version wouldn't work for me anyway. 
If you think it would be very important datapoint, I can try.


> You may want to check the per device queue configuration, lsscsi -L

"queue_depth=256", same for all disks

