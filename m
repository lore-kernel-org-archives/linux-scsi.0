From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/2] scsi_scan: Send TEST UNIT READY to the LUN before
 scanning
Date: Sun, 14 Sep 2014 10:17:21 +0200
Message-ID: <54154F11.4010305@suse.de>
References: <1401953203-103015-1-git-send-email-hare@suse.de> <1401953203-103015-2-git-send-email-hare@suse.de> <20140907162406.GA10775@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752397AbaINIRZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Sep 2014 04:17:25 -0400
In-Reply-To: <20140907162406.GA10775@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Robert Elliot <elliot@hp.com>, linux-scsi@vger.kernel.org

On 09/07/2014 06:24 PM, Christoph Hellwig wrote:
> Looks like you put a version into the SuSE tree with a blacklist entr=
y
> just for the Fujitsu array that requires the TEST UNIT READY.  Can yo=
u
> send that version upstream as well?
>
I've just had reports that this is required, as it interferes with=20
NetApp arrays.
So I'll be reposting a combined series with that.

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
