From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] scsi: add scsi trace core function and put trace
	points
Date: Wed, 20 Jan 2010 03:38:18 -0500
Message-ID: <20100120083818.GB5020@infradead.org>
References: <4B56A621.2070301@jp.fujitsu.com> <yq1ockpky1h.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51970 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab0ATIiV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2010 03:38:21 -0500
Content-Disposition: inline
In-Reply-To: <yq1ockpky1h.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>, Frederic Weisbecker <fweisbec@gmail.com>, lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>, Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>

On Wed, Jan 20, 2010 at 02:58:34AM -0500, Martin K. Petersen wrote:
> >>>>> "Kei" == Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com> writes:
> 
> +	TP_printk("host_no=%u channel=%u id=%u lun=%u cmnd=(%s %s raw=%s) "
>                               ^^^^^^^^^^
> 
> I'm not sure anybody cares about channels in this millennium so that may
> be a waste of space.

IT;s still used for adressing things internally.  E.g. in sas we
typically map ports to them.

