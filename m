From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: SCSI's heuristics for enabling WRITE SAME still need work [was:
 dm mpath: disable WRITE SAME if it fails]
Date: Tue, 24 Sep 2013 11:37:20 +0200
Message-ID: <52415D50.508@redhat.com>
References: <20130919161043.GA27081@redhat.com> <20130920212142.GA17898@redhat.com> <yq1eh8jf8wq.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qe0-f51.google.com ([209.85.128.51]:52876 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab3IXJhG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Sep 2013 05:37:06 -0400
Received: by mail-qe0-f51.google.com with SMTP id ne12so2981312qeb.10
        for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2013 02:37:06 -0700 (PDT)
In-Reply-To: <yq1eh8jf8wq.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

Il 21/09/2013 00:03, Martin K. Petersen ha scritto:
> 
> The major headache here of course is that WRITE SAME is inherently
> destructive. We can't just fire off one during discovery and see if it
> works. For WRITE you can issue a command with a transfer length of 0 to
> see if things work. But unfortunately for WRITE SAME a transfer length
> of zero means "wipe the entire device". Yikes!

What about WRITE SAME with an out-of-range lba?  Or lba equal to the
size of the disk and #blocks equal to zero.

Paolo
