From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 0/3] CXL Flash Error Recovery and Superpipe
Date: Tue, 11 Aug 2015 09:24:19 -0500
Message-ID: <FAE857F9-A2DD-4912-9102-4A5EFF26B0A5@linux.vnet.ibm.com>
References: <1439226565-7700-1-git-send-email-mrochs@linux.vnet.ibm.com> <1439256739.5081.36.camel@neuling.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:58088 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964946AbbHKOYX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2015 10:24:23 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 11 Aug 2015 08:24:23 -0600
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id D45A73E4003F
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 08:24:20 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7BEOKmi41877588
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 07:24:20 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7BEOIvs017262
	for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 08:24:20 -0600
In-Reply-To: <1439256739.5081.36.camel@neuling.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Neuling <mikey@neuling.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, hch@infradead.org, imunsie@au1.ibm.com, dja@ozlabs.au.ibm.com

> On Aug 10, 2015, at 8:32 PM, Michael Neuling <mikey@neuling.org> wrote:
> 
>> This patch set is intended for the 4.3 release and adds support for
>> error recovery and the superpipe features provided by the IBM CXL
>> Flash adapter. The superpipe function was originally presented in an
>> RFC patch set in late April. To aid with the review of the superpipe
>> portion of these enhancements, we have further split it across the
>> last two patches in this set. Please reference the changelog below
>> for details on what has been altered from previous versions of this
>> patchset.
> 
> Worth noting here that this depends on the original cxlflash patch from
> here:
>  http://permalink.gmane.org/gmane.linux.scsi/102357

Noted, will include this blurb in v5 cover letter.

> 
>> v4 Changes:
>> - Removes patch of legacy fixes/refactoring
> 
> Are you going to repost these as a separate series?

Yes.



