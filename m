From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RESEND PATCH v2 0/2] Update SCSI target removal path
Date: Wed, 30 Mar 2016 09:43:28 -0700
Message-ID: <1459356208.2509.9.camel@HansenPartnership.com>
References: <cover.1459249252.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47880 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055AbcC3Qnd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Mar 2016 12:43:33 -0400
In-Reply-To: <cover.1459249252.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Ewan D. Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2016-03-30 at 09:09 +0200, Johannes Thumshirn wrote:
> [resend with linux-scsi@ in Cc, my apologies]
> 
> This is a follow up to "scsi: Add intermediate STARGET_REMOVE state 
> to scsi_target_state".
> 
> If anyone has an idea how to create a regression test suite for the 
> target removal path I'd be all ears, given the fact that this is the 
> 3rd or 4th patch targeting it.

Actually, could you reverse the order of these patches, please.  It's
not safe to revert the soft lockup fix until after the intermediate
state is introduced.  I'd rather we didn't go through a point in the
tree where the bug exists again.

Thanks,

James


