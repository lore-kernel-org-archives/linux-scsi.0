From: Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH-v2 11/12] xen-scsiback: Convert to percpu_ida tag
 allocation
Date: Mon, 25 Jan 2016 16:42:15 +0100
Message-ID: <56A64257.4000601@suse.com>
References: <1453709466-6308-1-git-send-email-nab@daterainc.com>
 <1453709466-6308-12-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35482 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753138AbcAYPmT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jan 2016 10:42:19 -0500
In-Reply-To: <1453709466-6308-12-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Nicholas Bellinger <nab@linux-iscsi.org>, David Vrabel <david.vrabel@citrix.com>

On 25/01/16 09:11, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Cc: Juergen Gross <jgross@suse.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: David Vrabel <david.vrabel@citrix.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

Could you please rebase to current version? The patch won't apply.


Juergen
