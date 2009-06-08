From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/4] iscsi class, libiscsi: Add net config.
Date: Mon, 08 Jun 2009 15:24:21 -0500
Message-ID: <4A2D7375.1000307@cs.wisc.edu>
References: <1241208039-6813-1-git-send-email-mchan@broadcom.com>	 <1241208039-6813-4-git-send-email-mchan@broadcom.com> <1244483774.4079.368.camel@mulgrave.site> <4A2D5374.3030503@cs.wisc.edu> <4A2D6F64.7020502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46622 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909AbZFHUYo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Jun 2009 16:24:44 -0400
In-Reply-To: <4A2D6F64.7020502@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: open-iscsi@googlegroups.com, James Bottomley <James.Bottomley@HansenPartnership.com>, Michael Chan <mchan@broadcom.com>, davem@davemloft.net, netdev@vger.kernel.org, linux-scsi@vger.kernel.org

Hans de Goede wrote:
> <snip>
> 
> Sorry for jumping in the middle of a thread, I missed the
> libiscsi in the subject. Can someone please resent me the
> libiscsi part of this patchset so that I can review it ?
> 
> (I'm the libiscsi author)
> 

There is actually a kernel module called libiscsi. That is what this 
patch/thread/mail is for. It is not the userpsace libiscsi lib that you did.
