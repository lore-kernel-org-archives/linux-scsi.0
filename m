From: Keith Hopkins <vger@hopnet.net>
Subject: Re: aic94xx: failing on high load (another data point)
Date: Sat, 16 Feb 2008 00:28:41 +0800
Message-ID: <47B5BDB9.204@hopnet.net>
References: <479FB3ED.3080401@hopnet.net>	<20080130091403.GA14887@alaris.suse.cz> <47A05896.40900@hopnet.net>	<20080130192947.GA21785@tree.beaverton.ibm.com>	<47B4682C.4020505@hopnet.net> <1203089323.3058.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [221.218.196.247] ([221.218.196.247]:37746 "EHLO
	mail.hopnet.net" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753667AbYBOQ1b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Feb 2008 11:27:31 -0500
In-Reply-To: <1203089323.3058.20.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

On 02/15/2008 11:28 PM, James Bottomley wrote:
> If you're willing, could you try this patch which may correct the
> problem?  It's sort of like falling off a cliff: if you never go near
> the edge (i.e. you upgrade the drive fw) you never fall off;
> alternatively, it would be nice if you could help me put up guard rails
> just in case.

Hi James,

  Thanks for your feedback & suggestions.  Yes, I'll give the patch a try.  It might take a few days to get onto the system.  The system/drive isn't IBM, but I'll also see if I can track down a firmware update too for the protocol errors.

--Keith


