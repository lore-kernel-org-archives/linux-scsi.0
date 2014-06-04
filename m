From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: replace numeric messages with string error messages
 when blk_execute_rq fails.  Also add printing of sense info.
Date: Wed, 04 Jun 2014 09:53:10 +0200
Message-ID: <538ED066.7010604@suse.de>
References: <1398167056-14582-1-git-send-email-mlombard@redhat.com> <20140425131219.GA20644@lst.de> <20140429093035.GA2219@dhcp-27-189.brq.redhat.com> <20140429180041.GB26194@lst.de> <20140513131015.GB2015@dhcp-27-189.brq.redhat.com> <20140513140724.GA4618@lst.de> <537228D7.3080306@suse.de> <20140513142401.GC2015@dhcp-27-189.brq.redhat.com> <20140515064110.GA7410@lst.de> <20140604075122.GA5700@dhcp-27-189.brq.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176AbaFDHxM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jun 2014 03:53:12 -0400
In-Reply-To: <20140604075122.GA5700@dhcp-27-189.brq.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, JBottomley@Parallels.com

On 06/04/2014 09:51 AM, Maurizio Lombardi wrote:
> On Thu, May 15, 2014 at 08:41:10AM +0200, Christoph Hellwig wrote:
>>
>> We now have a readily available copy of EVPD page 0x83 hanging off
>> the scsi device, so the alua device handler should use it.
>>
>> Hannes, how about you handle that if you're doing major surgery in t=
hat
>> area anwyay?
>
> Hannes?
>
> Did you notice this email?
>
Oh, yes, I did.
Will be sending a patch shortly.

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
