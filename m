From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] remove name length check in a workqueue
Date: Wed, 10 Aug 2005 12:24:32 -0500
Message-ID: <1123694672.5134.11.camel@mulgrave>
References: <1123683544.5093.4.camel@mulgrave>
	 <Pine.LNX.4.58.0508101044110.31617@devserv.devel.redhat.com>
	 <20050810100523.0075d4e8.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:39831 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965223AbVHJRYw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2005 13:24:52 -0400
In-Reply-To: <20050810100523.0075d4e8.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-08-10 at 10:05 -0700, Andrew Morton wrote:
> Ingo Molnar <mingo@redhat.com> wrote:
> > yeah ... cannot remember why i have done it originally :-|

> Might it be to do with sizeof(task_struct.comm)?

But that's 16 bytes not 10; and anyway, it doesn't have to be unique;
set_task_comm just does a strlcpy from the name, so it will be truncated
(same as for a binary with > 15 character name).

James


