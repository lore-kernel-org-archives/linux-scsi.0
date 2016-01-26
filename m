From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 11/12] xen-scsiback: Convert to percpu_ida tag
 allocation
Date: Mon, 25 Jan 2016 21:15:15 -0800
Message-ID: <1453785315.6746.69.camel@haakon3.risingtidesystems.com>
References: <1453709466-6308-1-git-send-email-nab@daterainc.com>
	 <1453709466-6308-12-git-send-email-nab@daterainc.com>
	 <56A64257.4000601@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <56A64257.4000601@suse.com>
Sender: target-devel-owner@vger.kernel.org
To: Juergen Gross <jgross@suse.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, David Vrabel <david.vrabel@citrix.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2016-01-25 at 16:42 +0100, Juergen Gross wrote:
> On 25/01/16 09:11, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Cc: Juergen Gross <jgross@suse.com>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: David Vrabel <david.vrabel@citrix.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Could you please rebase to current version? The patch won't apply.
> 

Yep, will be updating target-pending/queue-next to v4.5-rc1 over the
next days.
