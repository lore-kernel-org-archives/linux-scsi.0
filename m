From: Chris Friesen <chris.friesen@windriver.com>
Subject: Re: absurdly high "optimal_io_size" on Seagate SAS disk
Date: Fri, 7 Nov 2014 15:04:27 -0600
Message-ID: <545D33DB.3070904@windriver.com>
References: <545BA625.40308@windriver.com> <545BAD05.3050800@windriver.com>	<yq1k338b5d5.fsf@sermon.lab.mkp.net> <545BB3AB.8070409@windriver.com>	<yq1fvdwb3lq.fsf@sermon.lab.mkp.net> <545BC88A.7060706@windriver.com>	<yq1zjc3ai4h.fsf@sermon.lab.mkp.net> <545C5A1B.9020206@windriver.com>	<yq1bnoj9dvu.fsf@sermon.lab.mkp.net> <545D13FF.6090306@windriver.com> <yq1389u95wu.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:55826 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbaKGVEh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2014 16:04:37 -0500
In-Reply-To: <yq1389u95wu.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>

On 11/07/2014 01:17 PM, Martin K. Petersen wrote:

> I'd suggest trying /dev/sgN instead.

That seems to work.  Much appreciated.

And it's now showing an "optimal_io_size" of 0, so I think the issue is 
dealt with.

Thanks for all the help, it's been educational. :)

Chris
