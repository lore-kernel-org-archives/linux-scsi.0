From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] scsi: fix the build warning
Date: Thu, 22 Aug 2013 23:49:45 +0900
Message-ID: <CAC5umyhVNcwu2k7wEND5DvxRGE+_tyWBNpWjVdQ9DRTyV2qCaw@mail.gmail.com>
References: <1377132262-15744-1-git-send-email-zwu.kernel@gmail.com>
	<1377133329.12003.9.camel@joe-AO722>
	<CAEH94Lhh11+zFHsRNDXoyxQfndxDRMcVvLnZDXQLw5cyaavUJw@mail.gmail.com>
	<1377134271.12003.15.camel@joe-AO722>
	<yq1ppt68qk9.fsf@sermon.lab.mkp.net>
	<CAC5umyjHqqNnS_LAP_bfU0zs52JbuAYr9jLwDhgaQ7TmrACUHA@mail.gmail.com>
	<1377181627.2009.2.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377181627.2009.2.camel@dabdike.int.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Joe Perches <joe@perches.com>, Zhi Yong Wu <zwu.kernel@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-kernel mlist <linux-kernel@vger.kernel.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, Paul Bolle <pebolle@tiscali.nl>, Douglas Gilbert <dgilbert@interlog.com>
List-Id: linux-scsi@vger.kernel.org

2013/8/22 James Bottomley <jbottomley@parallels.com>:
> On Thu, 2013-08-22 at 21:42 +0900, Akinobu Mita wrote:
>> 2013/8/22 Martin K. Petersen <martin.petersen@oracle.com>:
>> >>>>>> "Joe" == Joe Perches <joe@perches.com> writes:
>> >
>> > Joe> I don't get this build warning in the first place and I think the
>> > Joe> scsi_debug file is quite old and probably doesn't need to be
>> > Joe> changed at all.
>> >
>> > guard isn't a boolean, it selects the checksum algorithm used.
>> >
>> > Also, I believe Akinobu's recent reorganization of this code in question
>> > fixed the warning.
>>
>> Unfortunately, this warning isn't fixed in linux-next, either.
>> Paul Bolle also sent a patch that fixes the same warning in a little
>> bit different way.
>
> Well, it is and it isn't.  Whether you see the warning seems to depend
> on how gcc was built.  My take is that an impossible default case just
> to keep some versions of gcc quiet is a bit pointless.

As Joe said in the other reply, scsi_debug_guard could be a negative
value (scsi_debug_guard > 1 is only prohibited).  So this warning
does not seem a false positive.
