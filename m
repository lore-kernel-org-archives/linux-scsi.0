From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [RESEND PATCH v2 2/2] scsi: Add intermediate STARGET_REMOVE
 state to scsi_target_state
Date: Wed, 30 Mar 2016 23:44:56 +0200
Message-ID: <20160330234456.00004733@localhost>
References: <cover.1459249252.git.jthumshirn@suse.de>
	<108843b606da2c793bd830af42d5907bf8776d13.1459249252.git.jthumshirn__45300.0338202857$1459322118$gmane$org@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <108843b606da2c793bd830af42d5907bf8776d13.1459249252.git.jthumshirn__45300.0338202857$1459322118$gmane$org@suse.de>
Sender: stable-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Ewan D. Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Sebastian Herbszt <herbszt@gmx.de>
List-Id: linux-scsi@vger.kernel.org

Johannes Thumshirn wrote:
> Add intermediate STARGET_REMOVE state to scsi_target_state to avoid running
> into the BUG_ON() in scsi_target_reap().
> 
> This intermediate state is only valid in the path from scsi_remove_target() to
> scsi_target_destroy() indicating this target is going to be removed.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> Fixes: 40998193560dab6c3ce8d25f4fa58a23e252ef38
> Cc: stable@vger.kernel.org
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Reviewed-by: Ewan D. Milne <emilne@redhat.com>
> ---
> 
> Changes from v1:
> * The state transition from STARGET_CREATED to STARGET_DEL is legitimate,
>   so don't BUG() on it. Found by the 0-Day Bot.

This is yet another attempt to fix 40998193560d. Can you please explain how
it is "superior" to the one proposed by Bart before [1] ?

[1] http://marc.info/?l=linux-scsi&m=145227191917602&w=2

Sebastian
