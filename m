From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: absurdly high "optimal_io_size" on Seagate SAS disk
Date: Fri, 07 Nov 2014 14:17:37 -0500
Message-ID: <yq1389u95wu.fsf@sermon.lab.mkp.net>
References: <545BA625.40308@windriver.com> <545BAD05.3050800@windriver.com>
	<yq1k338b5d5.fsf@sermon.lab.mkp.net> <545BB3AB.8070409@windriver.com>
	<yq1fvdwb3lq.fsf@sermon.lab.mkp.net> <545BC88A.7060706@windriver.com>
	<yq1zjc3ai4h.fsf@sermon.lab.mkp.net> <545C5A1B.9020206@windriver.com>
	<yq1bnoj9dvu.fsf@sermon.lab.mkp.net> <545D13FF.6090306@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <545D13FF.6090306@windriver.com> (Chris Friesen's message of
	"Fri, 7 Nov 2014 12:48:31 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Friesen <chris.friesen@windriver.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Chris" == Chris Friesen <chris.friesen@windriver.com> writes:

Chris> Apparently the "hdparm -I" command is giving bogus data as well.
Chris> I've seen that happen if the drive is on a RAID controller--I
Chris> assume that could cause problems with firmware updates too?

I'd suggest trying /dev/sgN instead.

But yes, some RAID controllers require you to use their tooling and
won't allow direct passthrough.

-- 
Martin K. Petersen	Oracle Linux Engineering
