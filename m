From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCHv2 0/7] Limit overall SCSI EH runtime
Date: Fri, 26 Jul 2013 17:52:06 +0800
Message-ID: <51F246C6.4090003@cn.fujitsu.com>
References: <1372661455-122384-1-git-send-email-hare@suse.de>  <1373488528.7420.55.camel@localhost.localdomain>  <51DF9A25.5030502@cn.fujitsu.com> <1373635840.7420.139.camel@localhost.localdomain> <51E3CFF5.2070501@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:49492 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab3GZJry (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Jul 2013 05:47:54 -0400
In-Reply-To: <51E3CFF5.2070501@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: emilne@redhat.com, bmr@redhat.com, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>

Hi, Hannes:

On 07/15/2013 06:33 PM, Ren Mingxin wrote:
> I noticed that the dd time had been reduced from 6m+ to 2m+ when the
> 'eh_deadline' was set as 30s, but the dd time was 6m+(nearly the same
> as default - 'eh_deadline' was 0) when the 'eh_deadline' was set as
> 10s. I havn't been able to dig further, but I guess there is some
> restriction when setting this 'eh_deadline' interface. Maybe should
> not less than some timeout, otherwise 'eh_deadline' setting will not
> work?

I've retried and confirmed that the exception above is caused by
misoperation - for I had two fc hosts to build a failover multipath,
but I just set 'eh_deadline' on one host. When I tested with 10s,
the 'eh_deadline' on the host of the active path wasn't set :-(

Sorry for my mistake. So:

Tested-by: Ren Mingxin <renmx@cn.fujitsu.com>

Thanks,
Ren

