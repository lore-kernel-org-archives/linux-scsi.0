From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH] scsi: fix the build warning
Date: Thu, 22 Aug 2013 14:27:07 +0000
Message-ID: <1377181627.2009.2.camel@dabdike.int.hansenpartnership.com>
References: <1377132262-15744-1-git-send-email-zwu.kernel@gmail.com>
	 <1377133329.12003.9.camel@joe-AO722>
	 <CAEH94Lhh11+zFHsRNDXoyxQfndxDRMcVvLnZDXQLw5cyaavUJw@mail.gmail.com>
	 <1377134271.12003.15.camel@joe-AO722> <yq1ppt68qk9.fsf@sermon.lab.mkp.net>
	 <CAC5umyjHqqNnS_LAP_bfU0zs52JbuAYr9jLwDhgaQ7TmrACUHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:55694 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab3HVO1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Aug 2013 10:27:14 -0400
In-Reply-To: <CAC5umyjHqqNnS_LAP_bfU0zs52JbuAYr9jLwDhgaQ7TmrACUHA@mail.gmail.com>
Content-Language: en-US
Content-ID: <DBB14323A0DE6049A4B6245ABACF6117@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Joe Perches <joe@perches.com>, Zhi Yong Wu <zwu.kernel@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-kernel mlist <linux-kernel@vger.kernel.org>, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, Paul Bolle <pebolle@tiscali.nl>, Douglas Gilbert <dgilbert@interlog.com>

On Thu, 2013-08-22 at 21:42 +0900, Akinobu Mita wrote:
> 2013/8/22 Martin K. Petersen <martin.petersen@oracle.com>:
> >>>>>> "Joe" == Joe Perches <joe@perches.com> writes:
> >
> > Joe> I don't get this build warning in the first place and I think the
> > Joe> scsi_debug file is quite old and probably doesn't need to be
> > Joe> changed at all.
> >
> > guard isn't a boolean, it selects the checksum algorithm used.
> >
> > Also, I believe Akinobu's recent reorganization of this code in question
> > fixed the warning.
> 
> Unfortunately, this warning isn't fixed in linux-next, either.
> Paul Bolle also sent a patch that fixes the same warning in a little
> bit different way.

Well, it is and it isn't.  Whether you see the warning seems to depend
on how gcc was built.  My take is that an impossible default case just
to keep some versions of gcc quiet is a bit pointless.

James

