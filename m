From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: 3.12.0: sda2: WRITE SAME failed. Manually zeroing. with 3w-xxxx driver
Date: Thu, 28 Nov 2013 08:13:07 -0500
Message-ID: <yq1d2lkllek.fsf@sermon.lab.mkp.net>
References: <CAO9zADw-k+Qghk79yzwzaiYiPSoQnKwjjTBwrhcOrJxTWc-fOQ@mail.gmail.com>
	<yq1iovclm0m.fsf@sermon.lab.mkp.net>
	<00c701ceec3a$c8bcfc90$5a36f5b0$@lucidpixels.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00c701ceec3a$c8bcfc90$5a36f5b0$@lucidpixels.com> (Justin
	Piszcz's message of "Thu, 28 Nov 2013 08:07:24 -0500")
Sender: linux-kernel-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: "'Martin K. Petersen'" <martin.petersen@oracle.com>, 'open list' <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Justin" == Justin Piszcz <jpiszcz@lucidpixels.com> writes:

Martin> I posted a patch a while back that prevents WRITE SAME being
Martin> issued for controllers that do not pass the commands through to
Martin> disk directly:

Martin>	http://marc.info/?l=linux-scsi&m=138252394614920&w=2

Justin> Awesome, thank you!  This patch is over a month old, do you know
Justin> if is currently in mainline? 

Nope. - James?

-- 
Martin K. Petersen	Oracle Linux Engineering
