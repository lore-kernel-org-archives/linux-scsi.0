From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: LSF/MM Schedule and improving discard support
Date: Thu, 07 Apr 2016 11:51:29 -0400
Message-ID: <1460044289.2311.5.camel@linux.vnet.ibm.com>
References: <57067F19.3030404@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:33407 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbcDGPvk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2016 11:51:40 -0400
Received: from localhost
	by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
	Thu, 7 Apr 2016 09:51:39 -0600
In-Reply-To: <57067F19.3030404@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Jens Axboe <axboe@fb.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

On Thu, 2016-04-07 at 08:39 -0700, Bart Van Assche wrote:
> Hello James,
> 
> Some time ago I proposed to discuss how to improve discard support 
> during the LSF/MM (http://thread.gmane.org/gmane.linux.scsi/110048). 
> I would appreciate it if this would be added to the LSF/MM agenda 
> since there has been no progress yet for the patch series I posted in
> December 2015.

Well, adding a cc to the lsf@ list to interest the attendees might have
been a good idea.

The basic problem with this topic is that it didn't really garner any
interest when you proposed it.  It also really just looks like there's
nothing to discuss: you just propose the unifying patch and people
discuss and modify that and it either gets accepted or not depending on
the level of the objections.

James


