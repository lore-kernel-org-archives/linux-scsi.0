From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCH 0/7] Limit overall SCSI EH runtime
Date: Thu, 27 Jun 2013 17:23:46 +0800
Message-ID: <51CC04A2.5090104@cn.fujitsu.com>
References: <1370862713-41323-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46956 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab3F0JUM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jun 2013 05:20:12 -0400
In-Reply-To: <1370862713-41323-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Smart <james.smart@emulex.com>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

Hi, Hannes & James:

On 06/10/2013 07:11 PM, Hannes Reinecke wrote:
> This patchset implements a new 'eh_deadline' attribute to the
> SCSI host. It will limit the overall SCSI EH runtime by a given
> timeout. If the timeout expires all intermediate steps will
> be skipped and host reset will be scheduled immediately.

First of all, I think this patchset is useful to restrict some actual
interminable EH processes. BTW: There were some patches which tried
to add user interface to customize different hardware reset levels to
shorten the EH duration, and unfortunately they were not accepted.
Your hard work on EH improvement is much appreciated:-)

But please let me know yourserialEH improvement jobs - will the
redundant environment(such as multipath, mirroring) be taken into
account specially? To this patchset, will just giving a appropriate
timeout to skip EH except for host reset is enough for a quick fail
over in redundant systems? In other words, do you think reserving the
host reset which will occupy the longest time in the escalated levels
is acceptable with redundant configuration?

Thanks,
Ren
