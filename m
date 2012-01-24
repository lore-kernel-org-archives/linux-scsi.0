From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [LSF/MM TOPIC] a few storage topics
Date: Tue, 24 Jan 2012 12:59:43 -0500
Message-ID: <yq162g13rsg.fsf@sermon.lab.mkp.net>
References: <CABE8wws67dn0fwhTCs_XqH0g_CxGuT+hPQH9cVFe1xx5t_O9Jw@mail.gmail.com>
	<20120117200609.GA7933@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:54545 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab2AXR7u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2012 12:59:50 -0500
In-Reply-To: <20120117200609.GA7933@redhat.com> (Mike Snitzer's message of
	"Tue, 17 Jan 2012 15:06:12 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> 1) expose WRITE SAME via higher level interface (ala
Mike>    sb_issue_discard) for more efficient zeroing on SCSI devices
Mike>    that support it

I actually thought I had submitted those patches as part of the thin
provisioning update. Looks like I held them back for some reason. I'll
check my notes to figure out why and get the kit merged forward ASAP!


Mike> 4) is anyone working on an interface to GET LBA STATUS?
Mike>    - Martin Petersen added GET LBA STATUS support to scsi_debug,
Mike>      but is there a vision for how tools (e.g. pvmove) could
Mike>      access such info in a uniform way across different vendors'
Mike>      storage?

I hadn't thought of that use case. Going to be a bit tricky given how
GET LBA STATUS works...

-- 
Martin K. Petersen	Oracle Linux Engineering
