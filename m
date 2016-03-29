From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi: Add intermediate STARGET_REMOVE state to
 scsi_target_state
Date: Tue, 29 Mar 2016 00:45:35 -0700
Message-ID: <20160329074535.GA30098@infradead.org>
References: <1458813373-7477-1-git-send-email-jthumshirn@suse.de>
 <1458834164.17965.74.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458834164.17965.74.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Mar 24, 2016 at 11:42:44AM -0400, Ewan D. Milne wrote:
> This looks fine.  Do we still need 90a88d6ef (scsi: fix soft lockup in
> scsi_remove_target() on module removal) or can that be reverted now,
> since the STARGET_REMOVE state will allow the iteration to continue?

Yes, that stale pointer check is something I'd really, really prefer
not to have around in the long run.

Otherwise the patch looks like the right direction to me.
