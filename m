From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: be2iscsi update
Date: Tue, 03 Apr 2012 23:04:01 -0500
Message-ID: <4F7BC831.7020800@cs.wisc.edu>
References: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59616 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab2DDED5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Apr 2012 00:03:57 -0400
Received: from [20.15.0.20] (c-24-118-21-114.hsd1.mn.comcast.net [24.118.21.114])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id q3443t2i016491
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 3 Apr 2012 23:03:56 -0500
In-Reply-To: <1332294488-13684-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 03/20/2012 08:47 PM, michaelc@cs.wisc.edu wrote:
> The following patches fix several bugs and add the ability to setup
> the cards networking. This patchset is a mix of fixes and features,
> so it is fine to merge for 3.5.
> 
> Maybe patches 01/17 - 13/17 could qualify for 3.4 since they are
> bugfixes or trivial patches like copyright or typo fixes, but I
> realize I am sending this late so I am not counting on any of it
> making 3.4.
> 

There were a couple bugs/issues in these patches. I want to Nack this
set since it is not merged yet. I will resend a new version of the set
that fixes the issues with the patches.
