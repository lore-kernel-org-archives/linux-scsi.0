From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: 3.12.0: sda2: WRITE SAME failed. Manually zeroing. with 3w-xxxx driver
Date: Thu, 05 Dec 2013 19:35:38 -0500
Message-ID: <yq1ob4uhl45.fsf@sermon.lab.mkp.net>
References: <CAO9zADw-k+Qghk79yzwzaiYiPSoQnKwjjTBwrhcOrJxTWc-fOQ@mail.gmail.com>
	<yq1iovclm0m.fsf@sermon.lab.mkp.net>
	<00c701ceec3a$c8bcfc90$5a36f5b0$@lucidpixels.com>
	<yq1d2lkllek.fsf@sermon.lab.mkp.net>
	<010b01ceec84$27643580$762ca080$@lucidpixels.com>
	<018b01cef213$d34d1df0$79e759d0$@lucidpixels.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <018b01cef213$d34d1df0$79e759d0$@lucidpixels.com> (Justin
	Piszcz's message of "Thu, 5 Dec 2013 18:43:39 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: "'Martin K. Petersen'" <martin.petersen@oracle.com>, 'open list' <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Justin" == Justin Piszcz <jpiszcz@lucidpixels.com> writes:

Justin> Update: System uptime with the patch is 7+ days under extensive
Justin> load at times and I've had no issues to date.  I just checked
Justin> the current linux git repo (3.13-rc2) and found this patch has
Justin> not been included.

James has it queued in scsi/fixes. It'll make it to Linus on the next
pull and it has been tagged for inclusion in stable.

-- 
Martin K. Petersen	Oracle Linux Engineering
