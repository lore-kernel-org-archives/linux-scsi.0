From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3 of 7] block: Find bio sector offset given idx and offset
Date: Mon, 09 Jun 2008 12:15:35 -0400
Message-ID: <yq1fxrmk2jc.fsf@sermon.lab.mkp.net>
References: <318fa71e735d25003f9c.1212814536@sermon.lab.mkp.net>
	<x498wxebnhc.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:38055 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbYFIQQo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2008 12:16:44 -0400
In-Reply-To: <x498wxebnhc.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's message of "Mon\, 09 Jun 2008 12\:07\:59 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>>>>> "Jeff" == Jeff Moyer <jmoyer@redhat.com> writes:

Jeff> Unless I've missed something, this helper isn't used anywhere in
Jeff> your patchset.

You are right.

bio_sector_offset() is used in the patch that adds integrity support
to DM.  I didn't post the MD/DM patches this time around in an attempt
to limit the number of patches and focus on the core code.

You can see the DM patch here:

http://oss.oracle.com/mercurial/mkp/linux-2.6-di/rev/6b79173c501a

-- 
Martin K. Petersen	Oracle Linux Engineering

