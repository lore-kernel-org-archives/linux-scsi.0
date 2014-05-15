From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 3/5] qla2xxx: Restrict max_luns to 16-bit for older HBAs
Date: Thu, 15 May 2014 10:47:27 +0200
Message-ID: <53747F1F.3030800@suse.de>
References: <1386673515-87133-1-git-send-email-hare@suse.de> <1386673515-87133-4-git-send-email-hare@suse.de> <alpine.WNT.2.00.1312101325550.5984@N5102REMCQXM4BS.qlogic.org> <20140515063812.GA16326@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42439 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbaEOIr3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 May 2014 04:47:29 -0400
In-Reply-To: <20140515063812.GA16326@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Chad Dupuis <chad.dupuis@qlogic.com>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 05/15/2014 08:38 AM, Christoph Hellwig wrote:
> On Tue, Dec 10, 2013 at 01:26:21PM -0500, Chad Dupuis wrote:
>>> +	if (!IS_QLAFX00(ha) && !IS_FWI2_CAPABLE(ha)) {
>>> +		/* HW supports only 16-bit LUNs */
>>> +		if (ql2xmaxlun > 0xffff)
>>> +			ql2xmaxlun =3D 0xffff;
>>> +	}
>>> 	host->max_lun =3D ql2xmaxlun;
>
> ql2xmaxlun is a global variable.  This should be changed to work on
> host->max_lun instead.
>
Right. Will be fixing it up.

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
