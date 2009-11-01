From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Add missing #include for include/scsi/osd_protocol.h
Date: Sun, 01 Nov 2009 13:25:43 +0200
Message-ID: <4AED7037.1080509@panasas.com>
References: <20091031093337.GA3339@deprecation.cyrius.com> <4AED5FBF.6020308@panasas.com> <20091101105416.GN20819@deprecation.cyrius.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:58498 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751884AbZKALZl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Nov 2009 06:25:41 -0500
In-Reply-To: <20091101105416.GN20819@deprecation.cyrius.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Michlmayr <tbm@cyrius.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, Randy Dunlap <randy.dunlap@oracle.com>

On 11/01/2009 12:54 PM, Martin Michlmayr wrote:
> * Boaz Harrosh <bharrosh@panasas.com> [2009-11-01 12:15]:
>>> include/scsi/osd_protocol.h is missing an #include, leading to:
>>> | include/scsi/osd_protocol.h:277: error: implicit declaration of function '__constant_cpu_to_be16'
>>> | include/scsi/osd_protocol.h:362: error: implicit declaration of function 'ALIGN'
>>
>> I cannot reproduce this problem. What platform  (ARCH/config) are you compiling
>> this?
> 
> Sorry, I forgot to say that this happens on ARM.

Yes I can see now linux/unaligned/le_byteshift.h and linux/unaligned/be_byteshift.h look
broken, they do not include headers who's definitions are used. All the other alternatives
in linux/unaligned/ ,example access_ok.h, do. Sigh

But one thing I do not understand, in linux-next is there not a single ARM platform that
does a "make allmodconfig". (Or they do but the compilation error was never reported?)

ACK-by: Boaz Harrosh <bharrosh@panasas.com>
