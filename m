From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: medium access timeout counter fails to reset
Date: Thu, 17 Apr 2014 15:23:50 -0400
Message-ID: <yq1tx9rep4p.fsf@sermon.lab.mkp.net>
References: <20140410150830.GA19457@fury.redhat.com>
	<1397490613.3832.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27868 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaDQTX6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Apr 2014 15:23:58 -0400
In-Reply-To: <1397490613.3832.20.camel@localhost.localdomain> (Ewan Milne's
	message of "Mon, 14 Apr 2014 11:50:13 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: linux-scsi@vger.kernel.org, djeffery@redhat.com

>>>>> "Ewan" == Ewan Milne <emilne@redhat.com> writes:

Ewan> Is there some reason why this patch was never accepted?  David
Ewan> posted it a couple of times last year and Martin ack'ed it, but I
Ewan> don't see it in your tree, and I don't see any other comments on
Ewan> it.

I still don't have any objections.

FWIW, the reason my patch didn't handle the recovery scenario is that
the devices I originally wrote it for never came back (irreversibly
stuck head assembly or dead FTL).

-- 
Martin K. Petersen	Oracle Linux Engineering
