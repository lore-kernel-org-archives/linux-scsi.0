From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/6] scsi: use 64-bit value for 'max_luns'
Date: Wed, 25 Jun 2014 14:31:31 +0200
Message-ID: <53AAC123.2060303@suse.de>
References: <1401785937-43581-1-git-send-email-hare@suse.de> <1401785937-43581-6-git-send-email-hare@suse.de> <20140625122856.GA3221@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140625122856.GA3221@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 06/25/2014 02:28 PM, Christoph Hellwig wrote:
> On Tue, Jun 03, 2014 at 10:58:56AM +0200, Hannes Reinecke wrote:
>> Now that we're using 64-bit LUNs internally we need to increase
>> the size of max_luns to 64 bits, too.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> Reviewed-by: Christoph Hellwig <hch@infradead.org>
>> Reviewed-by: Ewan Milne <emilne@redhat.com>
>
> I just noticed that this has changes to the module param code.
> These should be split into a separate patch and be ACKed by the modul=
es
> maintainer.  I'd still love to take the change through the SCSI tree =
to
> be able to get this into 3.17 easily.
>
> moduleparam changes below:
>
Guess I need to redo the patchset yet again ...
Oh well.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
