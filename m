From: Andi Kleen <ak@muc.de>
Subject: Re: Disk Errors
Date: Thu, 03 Feb 2005 09:18:21 +0100
Message-ID: <m1sm4eukdu.fsf@muc.de>
References: <60807403EABEB443939A5A7AA8A7458BBD5E44@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from one.firstfloor.org ([213.235.205.2]:15335 "EHLO
	one.firstfloor.org") by vger.kernel.org with ESMTP id S262787AbVBCISY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Feb 2005 03:18:24 -0500
In-Reply-To: <60807403EABEB443939A5A7AA8A7458BBD5E44@otce2k01.adaptec.com> (Mark
 Salyzyn's message of "Wed, 2 Feb 2005 09:12:57 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Bryan Henderson <hbryan@us.ibm.com>, Kit Gerrits <kit@gerritsacc.nl>, linux-scsi@vger.kernel.org

"Salyzyn, Mark" <mark_salyzyn@adaptec.com> writes:
>
> If the data is of the form to permit some loss, for example video, audio
> content or an error correcting stream of data, someone can make a case
> where READ_LONG is an appropriate action to take to help fill in missing
> content. 
>
> A fun thought ...


It's an interesting idea. How about adding a sysfs attribute for
the device that says "tolerate some errors". Default to off of course.
I guess a lot of people would value such an option while recovering
their disks.

-Andi
