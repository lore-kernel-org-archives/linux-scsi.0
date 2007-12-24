From: Rik van Riel <riel@redhat.com>
Subject: Re: 2.6.24-rc5-mm1 - SCSI/blkdev probing hang
Date: Mon, 24 Dec 2007 10:12:46 -0500
Message-ID: <20071224101246.1cd5edcb@bree.surriel.com>
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org>
	<20071220155745.1f079a3b@bree.surriel.com>
	<20071220132212.173fa493.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbXLXPMw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Dec 2007 10:12:52 -0500
In-Reply-To: <20071220132212.173fa493.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, 20 Dec 2007 13:22:12 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 20 Dec 2007 15:57:45 -0500
> Rik van Riel <riel@redhat.com> wrote:
> 
> > 2.6.24-rc5-mm1 seems to have a hang related to the SCSI or block
> > device probing code.

> It could be a scsi problem, or it could be all the kobject changes in
> Greg's driver tree.  Or a combination of the two.
> 
> Don't know, sorry.

Whatever it was, it's gone now.

2.6.24-rc6-mm1 boots on my system.
