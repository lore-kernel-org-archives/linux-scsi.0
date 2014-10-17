From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: PC partition tables are little endian
Date: Fri, 17 Oct 2014 17:24:03 +0200
Message-ID: <54413493.9050702@suse.de>
References: <1412188261-29632-1-git-send-email-hch@lst.de> <20141017131349.GB16538@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbaJQPYH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2014 11:24:07 -0400
In-Reply-To: <20141017131349.GB16538@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Douglas Gilbert <dgilbert@interlog.com>

On 10/17/2014 03:13 PM, Christoph Hellwig wrote:
> ping?
>
> On Wed, Oct 01, 2014 at 08:31:01PM +0200, Christoph Hellwig wrote:
>> As sparse correctly pointed out scsi_partsize should use get_unalign=
ed_le32
>> to read PC partition tables from disk, as they are little endian.
>>
>> The result of this bug is that we returned incorrect geometries on b=
ig
>> endian systems when using the scsicam variant.  Which probably doesn=
't
>> matter as only old x86 systems every cared about the geometry.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
