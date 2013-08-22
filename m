From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] scsi: fix the build warning
Date: Thu, 22 Aug 2013 21:42:44 +0900
Message-ID: <CAC5umyjHqqNnS_LAP_bfU0zs52JbuAYr9jLwDhgaQ7TmrACUHA@mail.gmail.com>
References: <1377132262-15744-1-git-send-email-zwu.kernel@gmail.com>
	<1377133329.12003.9.camel@joe-AO722>
	<CAEH94Lhh11+zFHsRNDXoyxQfndxDRMcVvLnZDXQLw5cyaavUJw@mail.gmail.com>
	<1377134271.12003.15.camel@joe-AO722>
	<yq1ppt68qk9.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1ppt68qk9.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Joe Perches <joe@perches.com>, Zhi Yong Wu <zwu.kernel@gmail.com>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, linux-kernel mlist <linux-kernel@vger.kernel.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, Paul Bolle <pebolle@tiscali.nl>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

2013/8/22 Martin K. Petersen <martin.petersen@oracle.com>:
>>>>>> "Joe" == Joe Perches <joe@perches.com> writes:
>
> Joe> I don't get this build warning in the first place and I think the
> Joe> scsi_debug file is quite old and probably doesn't need to be
> Joe> changed at all.
>
> guard isn't a boolean, it selects the checksum algorithm used.
>
> Also, I believe Akinobu's recent reorganization of this code in question
> fixed the warning.

Unfortunately, this warning isn't fixed in linux-next, either.
Paul Bolle also sent a patch that fixes the same warning in a little
bit different way.

http://marc.info/?l=linux-scsi&m=137404660520109&w=2
