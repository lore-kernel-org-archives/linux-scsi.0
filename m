From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 3 of 7] block: Find bio sector offset given idx and offset
Date: Tue, 10 Jun 2008 15:02:51 -0400
Message-ID: <x49ej759kpw.fsf@segfault.boston.devel.redhat.com>
References: <318fa71e735d25003f9c.1212814536@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754410AbYFJTDD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2008 15:03:03 -0400
In-Reply-To: <318fa71e735d25003f9c.1212814536@sermon.lab.mkp.net> (Martin
	K. Petersen's message of "Sat, 07 Jun 2008 00:55:36 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

> 2 files changed, 26 insertions(+)
> fs/bio.c            |   24 ++++++++++++++++++++++++
> include/linux/bio.h |    2 ++
>
>
> Helper function to find the sector offset in a bio given bvec index
> and page offset.
>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
