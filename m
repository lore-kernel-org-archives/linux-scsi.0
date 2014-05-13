From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: replace numeric messages with string error messages
 when blk_execute_rq fails.  Also add printing of sense info.
Date: Tue, 13 May 2014 16:14:47 +0200
Message-ID: <537228D7.3080306@suse.de>
References: <1398167056-14582-1-git-send-email-mlombard@redhat.com> <20140425131219.GA20644@lst.de> <20140429093035.GA2219@dhcp-27-189.brq.redhat.com> <20140429180041.GB26194@lst.de> <20140513131015.GB2015@dhcp-27-189.brq.redhat.com> <20140513140724.GA4618@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932564AbaEMOOx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 May 2014 10:14:53 -0400
In-Reply-To: <20140513140724.GA4618@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Maurizio Lombardi <mlombard@redhat.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@Parallels.com

On 05/13/2014 04:07 PM, Christoph Hellwig wrote:
> On Tue, May 13, 2014 at 03:10:15PM +0200, Maurizio Lombardi wrote:
>> Hannes Reinecke is also working on those functions, I'll have to col=
laborate
>> with him to minimize the conflicts with the patchset he is preparing=
=2E
>>
>> In the meantime, do you think it is possible to merge the first vers=
ion
>> of the patch (http://www.spinics.net/lists/linux-scsi/msg73984.html)=
?
>> We could proceed to rewrite the functions later.
>
> I'm fine with adding the pints, but what work is Hannes doing with
> scsi_execute at the moment?
>
I'm not doing any work with scsi_execute.
I do, however, have a patchset for rewriting scsi_dh_alua.
Which touches those areas.

If you were to go ahead with the patch please strip the first=20
scsi_execute() altogether and use the VPD information already provided=20
by the scsi device.

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
