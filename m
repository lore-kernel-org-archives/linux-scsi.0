From: Dave Jones <davej@redhat.com>
Subject: Re: Remove scsi_wait_scan module
Date: Thu, 31 May 2012 13:54:19 -0400
Message-ID: <20120531175419.GA5016@redhat.com>
References: <1338110026.2957.5.camel@dabdike.int.hansenpartnership.com>
 <20120528100015.GB10036@vostochny.stro.at>
 <1338206866.6330.22.camel@dabdike>
 <CAA9_cmfh9ZtepX+hjLVRM95u_pAe90kZTkBeVmFPWm8AMaqJ5g@mail.gmail.com>
 <1338420752.3069.20.camel@dabdike>
 <CAA9_cmfZFm5+9ARB7tNVwNzwxJh3bPD=h7gMWhByjy00-qZvgg@mail.gmail.com>
 <4FC7288C.302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138Ab2EaSD0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 May 2012 14:03:26 -0400
Content-Disposition: inline
In-Reply-To: <4FC7288C.302@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harald Hoyer <harald.hoyer@gmail.com>
Cc: Dan Williams <dan.j.williams@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, maximilian attems <max@stro.at>, linux-scsi <linux-scsi@vger.kernel.org>, Jeff Mahoney <jeffm@suse.de>, Ben Hutchings <ben@decadent.org.uk>, initramfs@vger.kernel.org

On Thu, May 31, 2012 at 10:15:08AM +0200, Harald Hoyer wrote:

 > For Fedora17 scsi_wait_scan is not used anymore in the normal initramfs.

Did/can you backport the same changes to F16 ?
If this module goes away, we don't want unpleasant surprises if we're still
dependant on it when we rebase the kernel.

	Dave

