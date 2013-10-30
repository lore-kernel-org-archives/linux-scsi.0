From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/4] blk-timeout: add BLK_EH_SCHEDULED return code
Date: Wed, 30 Oct 2013 20:15:19 +0100
Message-ID: <52715AC7.7010202@suse.de>
References: <1383122272-93572-1-git-send-email-hare@suse.de> <1383122272-93572-3-git-send-email-hare@suse.de> <20131030084303.GA3772@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab3J3RNZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 13:13:25 -0400
In-Reply-To: <20131030084303.GA3772@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>

On 10/30/2013 09:43 AM, Christoph Hellwig wrote:
> On Wed, Oct 30, 2013 at 09:37:50AM +0100, Hannes Reinecke wrote:
>> Add a 'BLK_EH_SCHEDULED' return code for blk-timeout to indicate
>> that a delayed error recovery has been initiated.
>
> The user introduces here gets immediately reverted in the next patch,
> which means this patch can simply be dropped.
>
Rah. You are right.

Will be redoing the patchset.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
