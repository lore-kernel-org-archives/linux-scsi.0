From: "Love, Robert W" <robert.w.love@intel.com>
Subject: RE: [PATCH 00/17] Open-FCoE Updates
Date: Thu, 26 Feb 2009 12:54:59 -0700
Message-ID: <273D38FBE7C6FE46A1689FCD014A0B8B3084D8B7@azsmsx505.amr.corp.intel.com>
References: <20090206185548.26188.51580.stgit@fritz>
	 <49A6033D.8040600@cs.wisc.edu>  <1235672974.4219.8.camel@fritz>
 <1235675105.19035.65.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25625 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbZBZTzD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Feb 2009 14:55:03 -0500
In-Reply-To: <1235675105.19035.65.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Thu, 2009-02-26 at 10:29 -0800, Robert Love wrote:
>> On Wed, 2009-02-25 at 18:49 -0800, Mike Christie wrote:
>>> Robert Love wrote:
>>>> The following series implements bug fixes, adds a module param for
>>>> runtime debug logging and cleans up some coding style issues. The
>>>> top patch is a patch that was posted to linux-scsi on 01/04, but
>>>> doesn't seem to have made it in yet.   
>>>> 
>>>> This patch set is based on Linus' tree + the Open-FCoE patches
>>>> submitted to linux-scsi on 01/21. 
>>>> 
>>> 
>>> Were these patches and that other patchset for 2.6.29-rc? This one
>>> had some non bug fixes. I was not sure if you can do that in a rc.
>>> I was not sure if because it is a new driver you get a exception
>>> since there can be no regressions. 
>>> 
>> They were intended for the RC phase, should I have been more
>> explicit? I'm not sure what the policy is exactly, I've heard that
>> the RC phase is only for regressions, but I'm not sure how that
>> applies to new drivers. We have nothing to regress from and I'd
>> prefer getting these fixes in so that FCoE in 2.6.29 is as stable as
>> can be. 
> 
> OK, so how it works is firstly you have to tell me it's for rc fixes
> ... I can sometimes get this from the subject (if it contains words
> like bug fix).   Secondly, I need enhancements and fixes separated so
> they can be separately applied to the different trees (if you have an
> entanglement, I can rebase the misc tree to pick up the needed
> rc-fixes dependencies). 
> 
> So if you separate the patches (or just tell me what's a bug fix ...
> and they apply individually) I can put them in the rc-fixes tree.
> 
Thanks for the clarification. I'll resend a clearly labeled patchset
of fixes. I'll also post the dynamic debug logging improvements I did
separately, labeled as a feature.