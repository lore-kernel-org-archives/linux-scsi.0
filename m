From: Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH 4/4] scsi: translate errors for power management
Date: Fri, 03 Aug 2012 14:22:55 +0200
Message-ID: <5306802.hhdiODGtmh@linux-lqwf.site>
References: <1343903227-17285-1-git-send-email-oliver@neukum.org> <1343903227-17285-5-git-send-email-oliver@neukum.org> <1343904224.5073.27.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36907 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375Ab2HCMX6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Aug 2012 08:23:58 -0400
In-Reply-To: <1343904224.5073.27.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, hare@suse.de

On Thursday 02 August 2012 11:43:44 James Bottomley wrote:
 
> this should be inside the switch as
> 
> default:
> 	return -EIO;
> 
> and no return statment outside of the switch.

OK

> Don't you still want to handle BUSY and QUEUE_FULL as -EBUSY?  Right at
> the moment they'll fall through the default case and return -EIO.

True. They should be handled.

	Regards
		Oliver

