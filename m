From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [dm-devel] [Lsf] Notes from the four separate IO track sessions
 at LSF/MM
Date: Thu, 28 Apr 2016 09:41:26 -0700
Message-ID: <57223D36.60304@sandisk.com>
References: <1461800389.2311.70.camel@HansenPartnership.com>
 <20160428121108.GA9903@redhat.com>
 <1461858038.2307.16.camel@HansenPartnership.com>
 <5722320E.5080202@sandisk.com>
 <610090691.32303585.1461860624844.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0063.outbound.protection.outlook.com ([65.55.169.63]:63424
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750943AbcD1Qlc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Apr 2016 12:41:32 -0400
In-Reply-To: <610090691.32303585.1461860624844.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, device-mapper development <dm-devel@redhat.com>, lsf@lists.linux-foundation.org

On 04/28/2016 09:23 AM, Laurence Oberman wrote:
> We still suffer from periodic complaints in our large customer base
 > regarding the long recovery times for dm-multipath.
> Most of the time this is when we have something like a switch
 > back-plane issue or an issue where RSCN'S are blocked coming back up
 > the fabric. Corner cases still bite us often.
>
> Most of the complaints originate from customers for example seeing
 > Oracle cluster evictions where during the waiting on the mid-layer
 > all mpath I/O is blocked until recovery.
>
> We have to tune eh_deadline, eh_timeout and fast_io_fail_tmo but
 > even tuning those we have to wait on serial recovery even if we
 > set the timeouts low.
>
> Lately we have been living with
> eh_deadline=10
> eh_timeout=5
> fast_fail_io_tmo=10
> leaving default sd timeout at 30s
>
> So this continues to be an issue and I have specific examples using
 > the jammer I can provide showing the serial recovery times here.

Hello Laurence,

The long recovery times you refer to, is that for a scenario where all 
paths failed or for a scenario where some paths failed and other paths 
are still working? In the latter case, how long does it take before 
dm-multipath fails over to another path?

Thanks,

Bart.
