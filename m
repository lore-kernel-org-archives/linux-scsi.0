From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] sd: WRITE SAME(16) / UNMAP support
Date: Fri, 30 Oct 2009 00:53:31 -0400
Message-ID: <yq1pr85scs4.fsf@sermon.lab.mkp.net>
References: <1256873409-12668-1-git-send-email-martin.petersen@oracle.com>
	<1256873409-12668-3-git-send-email-martin.petersen@oracle.com>
	<4AEA6B76.2010303@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:29297 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750794AbZJ3EzP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Oct 2009 00:55:15 -0400
In-Reply-To: <4AEA6B76.2010303@interlog.com> (Douglas Gilbert's message of
	"Fri, 30 Oct 2009 00:28:38 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, hch@infradead.org, axboe@kernel.dk, matthew@wil.cx, linux-scsi@vger.kernel.org

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> And if both are supported by the logical unit, the patch prefers
Doug> UNMAP?

Yes.

SBC states that if the device reports MAXIMUM UNMAP LBA COUNT > 1 and
MAXIMUM UNMAP DESCRIPTOR COUNT > 1 then the device supports UNMAP.  And
in that case that's what I'll issue.  In all other cases I'll send out
WRITE SAME(16).  I believe that approach is what's currently considered
best practice.

-- 
Martin K. Petersen	Oracle Linux Engineering
