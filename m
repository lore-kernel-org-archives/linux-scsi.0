From: worley@alum.mit.edu (Dale R. Worley)
Subject: Re: absurdly high "optimal_io_size" on Seagate SAS disk
Date: Fri, 7 Nov 2014 10:18:46 -0500
Message-ID: <201411071518.sA7FIkLu031394@hobgoblin.ariadne.com>
References: <545BA625.40308@windriver.com> <545BAD05.3050800@windriver.com>	<yq1k338b5d5.fsf@sermon.lab.mkp.net> <545BB3AB.8070409@windriver.com>	<yq1fvdwb3lq.fsf@sermon.lab.mkp.net> <545BC88A.7060706@windriver.com> <yq1zjc3ai4h.fsf@sermon.lab.mkp.net> <545C5A1B.9020206@windriver.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from resqmta-ch2-09v.sys.comcast.net ([69.252.207.41]:45665 "EHLO
	resqmta-ch2-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751317AbaKGPSt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Nov 2014 10:18:49 -0500
In-reply-to: <545C5A1B.9020206@windriver.com> (chris.friesen@windriver.com)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Friesen <chris.friesen@windriver.com>
Cc: martin.petersen@oracle.com, axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, snitzer@redhat.com

> From: Chris Friesen <chris.friesen@windriver.com>

> Also, I think it's wrong for filesystems and userspace to use it for 
> alignment.  In E.4 and E.5 in the "sbc3r25.pdf" doc, it looks like they 
> use the optimal granularity field for alignment, not the optimal 
> transfer length.

Everything you say suggests that "optimal transfer length" means
"there is a penalty for doing transfers *larger* than this", but
people have been treating it as "there is a penalty for doing
transfers *smaller* than this".  But the latter is the "optimal
transfer length granularity".

Dale
