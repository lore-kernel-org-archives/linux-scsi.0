From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [Lsf] Notes from the four separate IO track sessions at LSF/MM
Date: Thu, 28 Apr 2016 08:53:50 -0700
Message-ID: <5722320E.5080202@sandisk.com>
References: <1461800389.2311.70.camel@HansenPartnership.com>
 <20160428121108.GA9903@redhat.com>
 <1461858038.2307.16.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0068.outbound.protection.outlook.com ([65.55.169.68]:60331
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752366AbcD1PyA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2016 11:54:00 -0400
In-Reply-To: <1461858038.2307.16.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Snitzer <snitzer@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "lsf@lists.linux-foundation.org" <lsf@lists.linux-foundation.org>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 04/28/2016 08:40 AM, James Bottomley wrote:
> Well, the entire room, that's vendors, users and implementors
> complained that path failover takes far too long.  I think in their
> minds this is enough substance to go on.

The only complaints I heard about path failover taking too long came 
from people working on FC drivers. Aren't SCSI transport layer 
implementations expected to fail I/O after fast_io_fail_tmo expired 
instead of waiting until the SCSI error handler has finished? If so, why 
is it considered an issue that error handling for the FC protocol can 
take very long (hours)?

Thanks,

Bart.
