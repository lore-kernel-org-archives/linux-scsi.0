From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 33/38] libata: use __scsi_print_command()
Date: Mon, 29 Sep 2014 16:10:30 +0200
Message-ID: <54296856.2020104@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de> <1411991947-130166-34-git-send-email-hare@suse.de> <20140929140606.GB15925@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20140929140606.GB15925@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 09/29/2014 04:06 PM, Tejun Heo wrote:
> On Mon, Sep 29, 2014 at 01:59:02PM +0200, Hannes Reinecke wrote:
>> libata already uses an internal buffer, so we should be using
>> __scsi_print_command() here.
>>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: linux-ide@vger.kernel.org
>> Cc: LKML <linux-kernel@vger.kernel.org>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>=20
> Applied to libata/for-3.18.
>=20
> Thanks.
>=20
Errm.
Nice that you did, but it sort of relies for patches 01-32 to be
applied previously.
I'd rather apply your Signed-off-by: to the patch and have it
routed through the SCSI tree; that way we're sure it'll only be
applied if the previous patches are in.

Can you please pull it from libata to avoid build issues?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
