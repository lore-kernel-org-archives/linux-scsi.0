From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 03/12] target/configfs: Convert mappedlun + SCSI MIBs
	to RCU reader
Date: Wed, 13 May 2015 07:49:12 +0200
Message-ID: <20150513054912.GC20825@lst.de>
References: <1431422736-29125-1-git-send-email-nab@daterainc.com> <1431422736-29125-4-git-send-email-nab@daterainc.com> <5552697B.8050008@redhat.com> <1431493763.26897.36.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1431493763.26897.36.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 12, 2015 at 10:09:23PM -0700, Nicholas A. Bellinger wrote:
> > Why do we still need TRANSPORT_LUNFLAGS_INITIATOR_ACCESS? Isn't deve 
> > being not-NULL enough?
> > 
> 
> Yep, I think this can go as well.  Dropping now.

Also might be worth to add a helper that has the ->se_lun_acl check
in one place and documents why these callers want a dev_entry with
a proper ACL.  Also I think the ->se_lun checks should not be needed
here.
