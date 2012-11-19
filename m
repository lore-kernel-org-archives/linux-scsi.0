From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v9 05/10] libata: separate ATAPI code
Date: Mon, 19 Nov 2012 10:21:15 +0800
Message-ID: <50A9979B.1040309@intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com> <1352443922-13734-6-git-send-email-aaron.lu@intel.com> <20121112185710.GD5560@mtj.dyndns.org> <20121113124923.GA11672@aaronlu.sh.intel.com> <20121118150117.GK7306@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36005 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842Ab2KSCVE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 18 Nov 2012 21:21:04 -0500
In-Reply-To: <20121118150117.GK7306@mtj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

On 11/18/2012 11:01 PM, Tejun Heo wrote:
> On Tue, Nov 13, 2012 at 08:49:24PM +0800, Aaron Lu wrote:
>> On Mon, Nov 12, 2012 at 10:57:10AM -0800, Tejun Heo wrote:
>>> On Fri, Nov 09, 2012 at 02:51:57PM +0800, Aaron Lu wrote:
>>>> The atapi_eh_tur and atapi_eh_request_sense can be reused by ZPODD
>>>> code, so separate them out to a file named libata-atapi.c, and the
>>>> Makefile is modified accordingly. No functional changes should result
>>>> from this commit.
>>>
>>> Why is this change necessary?  This doesn't seem to help anything to
>>> me.
>>
>> Function zpready introduced in patch 6 used these 2 functions to see if
>> an ODD is in a zero power ready state.
> 
> And why zpready can't use the functions if they're in a different file?

Oh, sure, they can be used.

My thought is that, the 2 functions are for ATAPI and can be used by
libata-eh, libata-zpodd and maybe others in the future, so it deserves
a separate place. But if this is regarded as unnecessary, I will drop
this patch.

Thanks,
Aaron

