From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Bug 8366] aic79xx and aic7xxx driver issues
Date: Thu, 26 Jul 2007 17:29:18 -0400
Message-ID: <1185485358.3501.94.camel@localhost.localdomain>
References: <20070725010525.614621080E4@picon.linux-foundation.org>
	 <1185329683.3488.46.camel@localhost.localdomain>
	 <1185461780.14419.17.camel@fea.ornl.gov>
	 <1185462341.3501.62.camel@localhost.localdomain>
	 <1185480022.14419.58.camel@fea.ornl.gov>
	 <1185482804.3501.87.camel@localhost.localdomain>
	 <1185484390.3501.93.camel@localhost.localdomain>
	 <1185484597.14419.65.camel@fea.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:39553 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761429AbXGZV3U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 17:29:20 -0400
In-Reply-To: <1185484597.14419.65.camel@fea.ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: freelsjd@ornl.gov
Cc: bugme-daemon@bugzilla.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>

On Thu, 2007-07-26 at 17:16 -0400, Freels, James D. wrote:
> James, I would be glad to try the fix.  I can grab the changes below,
> but can you give me the patch command ?  I know how to patch the
> normal kernel sources.  Is this a patch for 2.6.22.1 ?

It was created against current git, but there should be little
difference in the aic driver between that and 2.6.22.1, so it should
apply there as well.

> cd /usr/src/linux-2.6.22.1
> 
> patch -p1 <../your_new_patch
> 
> where your_new_patch is in /usr/src  

Yes, that should do it.

James


