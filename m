From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [LSF/MM ATTEND] discuss blk-mq related to DM-multipath and
 status of XCOPY
Date: Wed, 07 Jan 2015 09:00:42 -0800
Message-ID: <1420650042.12144.21.camel@haakon3.risingtidesystems.com>
References: <CAMM=eLdGQ4wQDHy0ACzDsYOs0AYC+KAcx7Mx7FmpBTV293d41Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:50883 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775AbbAGRAn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2015 12:00:43 -0500
In-Reply-To: <CAMM=eLdGQ4wQDHy0ACzDsYOs0AYC+KAcx7Mx7FmpBTV293d41Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: lsf-pc@lists.linux-foundation.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Jej B <James.Bottomley@hansenpartnership.com>, device-mapper development <dm-devel@redhat.com>

On Sun, 2015-01-04 at 12:16 -0500, Mike Snitzer wrote:
> Hi,
> 
> I'd like to attend LSF (and the first day of Vault).
> 
> As a DM maintainer I'm open to discussing anything DM related.  In
> particular I'd like to at least have hallway track discussions with
> key people interested in DM multipath support for blk-mq devices.
> Keith Busch and I have gone ahead and implemented the bulk of this
> request-based DM support for blk-mq devices, see:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-for-3.20-blk-mq
> 
> But Bart says he is seeing inconsistent performance now that the code
> appears relatively stable.  I'll continue analyzing this aspect of
> things and by the time LSF rolls around I hope the code to be sorted.
> 
> Another topic we need to come to terms with is the state of XCOPY
> (whether the initial approach needs further work, etc) -- Mikulas
> Patocka reworked aspects of Martin's initial approach but it hasn't
> progressed upstream:
> https://www.redhat.com/archives/dm-devel/2014-October/msg00167.html

A big +1 on the host side XCOPY support bit.

--nab

