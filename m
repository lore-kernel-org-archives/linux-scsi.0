From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
Subject: RE: 3.12.0: sda2: WRITE SAME failed. Manually zeroing. with 3w-xxxx driver
Date: Thu, 5 Dec 2013 18:43:39 -0500
Message-ID: <018b01cef213$d34d1df0$79e759d0$@lucidpixels.com>
References: <CAO9zADw-k+Qghk79yzwzaiYiPSoQnKwjjTBwrhcOrJxTWc-fOQ@mail.gmail.com> <yq1iovclm0m.fsf@sermon.lab.mkp.net> <00c701ceec3a$c8bcfc90$5a36f5b0$@lucidpixels.com> <yq1d2lkllek.fsf@sermon.lab.mkp.net> <010b01ceec84$27643580$762ca080$@lucidpixels.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
In-Reply-To: <010b01ceec84$27643580$762ca080$@lucidpixels.com>
Content-Language: en-us
Sender: linux-ext4-owner@vger.kernel.org
To: "'Martin K. Petersen'" <martin.petersen@oracle.com>
Cc: 'open list' <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Thursday, November 28, 2013 8:13 AM
> 
> 
> Martin>	http://marc.info/?l=linux-scsi&m=138252394614920&w=2
> 
> Justin> Awesome, thank you!  This patch is over a month old, do you know
> Justin> if is currently in mainline?
> 
> Nope. - James?
> 
> Could it possibly get added to 3.12.x -stable as well? I've patched
against
> 3.12.0 for now -- I'll let you know if there are any issues-- so far so
> good, thanks again.
> 
> Justin.

Update:
System uptime with the patch is 7+ days under extensive load at times and
I've had no issues to date.
I just checked the current linux git repo (3.13-rc2) and found this patch
has not been included.

Please advise if any further testing or validation needs to be completed to
help get this into -stable/-mainline.

Justin.



