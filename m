From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/5] scsi_scan: Restrict sequential scan to 256 LUNs
Date: Fri, 28 Mar 2014 06:19:24 -0700
Message-ID: <533576DC.1060806@suse.de>
References: <1386673515-87133-1-git-send-email-hare@suse.de> <1386673515-87133-3-git-send-email-hare@suse.de> <20140327144926.GB16958@infradead.org> <53353137.2050603@suse.de> <20140328124747.GA18866@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33992 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbaC1NT0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2014 09:19:26 -0400
In-Reply-To: <20140328124747.GA18866@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On 03/28/2014 05:47 AM, Christoph Hellwig wrote:
> On Fri, Mar 28, 2014 at 01:22:15AM -0700, Hannes Reinecke wrote:
>> Because there is no guarantee that pre-SCSI-3 devices (or devices
>> announcing to be pre-SCSI-3) will not allow to scan more than 256
>> devices.
>> Thinking of older Symmetrix here with their weird 'SPC-3 masking as
>> SCSI-2' habit.
>
> Don't we have a blist entry for those to use REPORT LUNS anyway?

Symmetrix was just an example of weirdness ...

>>
>> Also currently we're allowing to scan beyond 256 without any
>> restrictions there might be installations out there which rely on
>> this behaviour.
>>
>> Hence this flag.
>
> Which doesn't really have an effect as-is as it's never set.
>
Because currently there are no target which would require them.
Obviously. But that doesn't mean there won't be any.

Note, this is just a safety net for backwards compability.
If you think we won't need it of course we can remove it.

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
