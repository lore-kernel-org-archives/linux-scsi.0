From: Chris Friesen <chris.friesen@windriver.com>
Subject: Re: absurdly high "optimal_io_size" on Seagate SAS disk
Date: Fri, 7 Nov 2014 11:51:40 -0600
Message-ID: <545D06AC.7000606@windriver.com>
References: <545BA625.40308@windriver.com> <545BAD05.3050800@windriver.com>	<yq1k338b5d5.fsf@sermon.lab.mkp.net> <545BB3AB.8070409@windriver.com>	<yq1fvdwb3lq.fsf@sermon.lab.mkp.net> <545BC88A.7060706@windriver.com>	<yq1zjc3ai4h.fsf@sermon.lab.mkp.net> <545C5A1B.9020206@windriver.com>	<yq1bnoj9dvu.fsf@sermon.lab.mkp.net> <yq1ioiq9abc.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1ioiq9abc.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 11/07/2014 11:42 AM, Martin K. Petersen wrote:
>>>>>> "Martin" == Martin K Petersen <martin.petersen@oracle.com> writes:
>
> Martin> I know there was a bug open with Seagate. I assume it has been
> Martin> fixed in their latest firmware.
>
> Seagate confirms that this issue was fixed about a year ago. Will
> provide more data when I have it.

Okay, thanks for the clarification (for this and the spec itself).

Apparently there's a new firmware available, dated Oct 13 but with no 
release notes.  We just tried updating the firmware on one of the drives 
in question and it failed from two different versions of linux, while 
Windows won't install because it doesn't like our SSD apparently.  Joy.

Chris
