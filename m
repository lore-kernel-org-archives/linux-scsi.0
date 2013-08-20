From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: SCSI core patches for kernel 3.12
Date: Tue, 20 Aug 2013 20:00:29 +0200
Message-ID: <5213AEBD.2020303@acm.org>
References: <52135B99.2000102@acm.org>  <1377015091.5302.47.camel@haakon3.risingtidesystems.com>  <52139608.5040608@acm.org> <1377018283.5302.48.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:57939 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab3HTSAc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Aug 2013 14:00:32 -0400
In-Reply-To: <1377018283.5302.48.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, David Milburn <dmilburn@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 08/20/13 19:04, Nicholas A. Bellinger wrote:
> On Tue, 2013-08-20 at 18:15 +0200, Bart Van Assche wrote:
>> On 08/20/13 18:11, Nicholas A. Bellinger wrote:
>>> On Tue, 2013-08-20 at 14:05 +0200, Bart Van Assche wrote:
>>>> This patch series consists of four patches that address device removal
>>>> issues and three patches that improve performance of the SCSI mid-layer.
>>>
>>> Perhaps it would be useful to know what the performance improvement
>>> actually is..?  Eg: fio numbers before and after.
>>
>> The optimizations in this patch series are micro-optimizations. Their
>> performance impact is small but measurable. Peak IOPS results are
>> improved by about 1% by each of these performance improvements for a
>> low-latency transport.
>
> So that is 250K to 252.5K per LUN, or what..?

The exact numbers depend on the number of CPU's in the initiator system, 
the number of CPU's in the target system, the transport type, HCA model, 
SCSI target stack configuration, target storage medium etc. If you want 
to verify yourself the impact of this patch without all these 
dependencies, that's possible by running a test against the scsi_debug 
driver.

Bart.

