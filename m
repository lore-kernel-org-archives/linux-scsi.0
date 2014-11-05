From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2 0/3] Initial ZAC support
Date: Wed, 05 Nov 2014 16:09:20 +0100
Message-ID: <545A3DA0.5060901@suse.de>
References: <1415189302-108476-1-git-send-email-hare@suse.de> <20141105150340.GA1326@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53191 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537AbaKEPJW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Nov 2014 10:09:22 -0500
In-Reply-To: <20141105150340.GA1326@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jbottomley@parallels.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On 11/05/2014 04:03 PM, Christoph Hellwig wrote:
> On Wed, Nov 05, 2014 at 01:08:19PM +0100, Hannes Reinecke wrote:
>> Hi all,
>>
>> this patchset updates the ATA stack to correctly detect
>> host-managed ZAC devices.
>=20
> And more importantly exports /dev/sg nodes from them so they can be
> actually be accessed.
>=20
> I'm fine with taking the whole series through the libata tree, so far
> there are no conflicting libsas changes on the radar.
>=20
Tejun?
I've made the requested changes of using taskfiles in libsas,
so everything should be fine now ...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
