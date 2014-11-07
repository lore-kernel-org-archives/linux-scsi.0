From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: absurdly high "optimal_io_size" on Seagate SAS disk
Date: Fri, 07 Nov 2014 13:03:47 -0500
Message-ID: <yq1egte99bw.fsf@sermon.lab.mkp.net>
References: <545BA625.40308@windriver.com> <545BAD05.3050800@windriver.com>
	<yq1k338b5d5.fsf@sermon.lab.mkp.net> <545BB3AB.8070409@windriver.com>
	<yq1fvdwb3lq.fsf@sermon.lab.mkp.net> <545BC88A.7060706@windriver.com>
	<yq1zjc3ai4h.fsf@sermon.lab.mkp.net> <545C5A1B.9020206@windriver.com>
	<yq1bnoj9dvu.fsf@sermon.lab.mkp.net>
	<yq1ioiq9abc.fsf@sermon.lab.mkp.net> <545D06AC.7000606@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <545D06AC.7000606@windriver.com> (Chris Friesen's message of
	"Fri, 7 Nov 2014 11:51:40 -0600")
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Friesen <chris.friesen@windriver.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Chris" == Chris Friesen <chris.friesen@windriver.com> writes:

Chris> Apparently there's a new firmware available, dated Oct 13 but
Chris> with no release notes.  We just tried updating the firmware on
Chris> one of the drives in question and it failed from two different
Chris> versions of linux,

Did you use sg_write_buffer or some special firmware update tool?

-- 
Martin K. Petersen	Oracle Linux Engineering
