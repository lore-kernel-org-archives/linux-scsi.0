From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/6] iscsi changes for scsi-misc
Date: Thu, 06 Feb 2014 20:20:47 -0600
Message-ID: <52F442FF.9020004@cs.wisc.edu>
References: <1387565627-5218-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:39834 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaBGCVL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Feb 2014 21:21:11 -0500
Received: from [20.15.0.3] (c-24-245-27-162.hsd1.mn.comcast.net [24.245.27.162])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.14.1/8.14.1) with ESMTP id s172KvYG009638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 6 Feb 2014 20:21:09 -0600
In-Reply-To: <1387565627-5218-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On 12/20/2013 12:53 PM, michaelc@cs.wisc.edu wrote:
> The following patches are some features and fixes for scsi-misc.
> 
> James, if you were going to merge the libiscsi locking changes here
> http://www.spinics.net/lists/linux-scsi/msg69903.html
> do not bother. The qlogic patches that were just merged had a conflict.
> The patches in the following emails should apply cleanly to misc.
> 

Ignore this patchset. It has a regression. I will resend when I am done
testing a fix.

