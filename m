From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCHv2 0/7] Limit overall SCSI EH runtime
Date: Wed, 07 Aug 2013 14:43:57 +0800
Message-ID: <5201ECAD.7000703@cn.fujitsu.com>
References: <1372661455-122384-1-git-send-email-hare@suse.de> <1373488528.7420.55.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:23064 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754219Ab3HGGja (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Aug 2013 02:39:30 -0400
In-Reply-To: <1373488528.7420.55.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: emilne@redhat.com, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>

Hi, James:

On 07/11/2013 04:35 AM, Ewan Milne wrote:
> Looks good.  We have been testing this extensively.
>
> Acked-by: Ewan D. Milne<emilne@redhat.com>

Do you think this patchset can be applied? If so, When? Perhaps you
are waiting for someone's feedback?

We've also tested and got the duration could be shortened from 6m26s
to 44s when 'eh_deadline' was set as 1s(the minimum value of timeout)
and 16M data were written(I/O processing time can be ignored - 0.7s).

As Ewan said, this is efficient to fast failover policy for redundant
environments.

Thanks,
Ren
