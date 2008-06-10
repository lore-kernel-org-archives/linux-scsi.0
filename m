From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0 of 7] Block/SCSI Data Integrity Support
Date: Tue, 10 Jun 2008 16:53:52 -0400
Message-ID: <x49wskx810f.fsf@segfault.boston.devel.redhat.com>
References: <patchbomb.1212814533@sermon.lab.mkp.net>
	<x491w35bbdi.fsf@segfault.boston.devel.redhat.com>
	<yq1iqwhia2m.fsf@sermon.lab.mkp.net>
	<x49mylt9lbn.fsf@segfault.boston.devel.redhat.com>
	<yq1abhtnhjb.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758342AbYFJUyH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2008 16:54:07 -0400
In-Reply-To: <yq1abhtnhjb.fsf@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Tue, 10 Jun 2008 16:47:52 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

>>>>>> "Jeff" == Jeff Moyer <jmoyer@redhat.com> writes:
>
> Jeff> So, is it safe to say that the library routines for
> Jeff> integrity-aware file systems have not been tested at all?
> Jeff> Specifically, I'm talking about: bio_integrity_tag_size
> Jeff> bio_integrity_set_tag bio_integrity_get_tag
>
> I have not tried using them from within a filesystem, if that's what
> you mean.  But I have attached random strings to bios and read them
> back later.

I was checking to see if you had exercised the code at all, and you
have.  Great!

Cheers,

Jeff
