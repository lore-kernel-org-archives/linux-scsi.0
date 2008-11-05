From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [Bug 11898] mke2fs hang on AIC79 device.
Date: Tue, 04 Nov 2008 19:55:56 -0600
Message-ID: <4910FD2C.5010907@cs.wisc.edu>
References: <20081105013205.816CA108057@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36396 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbYKEB4o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2008 20:56:44 -0500
In-Reply-To: <20081105013205.816CA108057@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

bugme-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=11898
> 
> 
> 
> 
> 
> ------- Comment #9 from alex.shi@intel.com  2008-11-04 17:32 -------
> I did bisect for this bug and find the following commit cause this problem.
> 
> commit f0c0a376d0fcd4c5579ecf5e95f88387cba85211
> Author: Mike Christie <michaelc@cs.wisc.edu>

Ok, I am looking into this.
