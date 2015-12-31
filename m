From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 08/20] scsi_dh_alua: use unique device id
Date: Thu, 31 Dec 2015 13:53:47 +0100
Message-ID: <5685255B.2070101@suse.de>
References: <1449560260-53407-1-git-send-email-hare@suse.de>
 <1449560260-53407-9-git-send-email-hare@suse.de>
 <20151230112024.GB14156@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60626 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbbLaMxv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Dec 2015 07:53:51 -0500
In-Reply-To: <20151230112024.GB14156@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jbottomley@odin.com>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 12/30/2015 12:20 PM, Christoph Hellwig wrote:
> On Tue, Dec 08, 2015 at 08:37:28AM +0100, Hannes Reinecke wrote:
>> Use scsi_vpd_lun_id() to assign a unique device identification
>> to the alua port group structure.
>
> I really hate the fix length arrays and how they are passed around.
>
You and me both.
I would love to be able to identify port group states by a simple 64bit=
=20
identifier, but SCSI Names throws everything into disarray,

> Can't you move the call to scsi_vpd_lun_id into alua_get_pg (alua_all=
oc_pg)?
>
Hmm. Think so, yes,

> Also I think the new alua_lookup_pg should be alua_find_get_pg or
> similar as it takes a reference on the pg.
>
Sure, no problem with that,

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
