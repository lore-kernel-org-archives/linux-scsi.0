From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] scsi: Erroneous handling of sense status in SCSI EH commands
Date: Tue, 25 Jan 2011 14:19:22 -0600
Message-ID: <4D3F304A.6010402@cs.wisc.edu>
References: <1295597274-5844-1-git-send-email-hare@suse.de>	 <4D39F16A.5020002@cs.wisc.edu> <4D3D317D.6060403@suse.de>	 <4D3DDE3F.2030902@cs.wisc.edu> <4D3E5D25.9000604@cs.wisc.edu>	 <4D3E60F0.80407@cs.wisc.edu> <1295969882.4955.82.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60835 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792Ab1AYUTN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jan 2011 15:19:13 -0500
In-Reply-To: <1295969882.4955.82.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On 01/25/2011 09:38 AM, James Bottomley wrote:
>> Ignore that. I see it is getting called for the host reset code. I am
>> not sure what happened when I was testing it.
>
> Just so I'm clear ... that's you withdrawing all objections to this
> patch, so I can put it in scsi-misc for testing?
>

Yeah.
