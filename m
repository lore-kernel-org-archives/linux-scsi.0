From: Juergen Gross <jgross@suse.com>
Subject: Re: Re: [PATCH 3/4] Introduce XEN scsiback module
Date: Fri, 11 Jul 2014 10:57:50 +0200
Message-ID: <53BFA70E.5040203@suse.com>
References: <1403879676-25431-1-git-send-email-jgross@suse.com> <1403879676-25431-4-git-send-email-jgross@suse.com> <20140628180953.GA10820@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751166AbaGKI5w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jul 2014 04:57:52 -0400
In-Reply-To: <20140628180953.GA10820@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, xen-devel@lists.xen.org, target-devel@vger.kernel.org

On 06/28/2014 08:09 PM, Christoph Hellwig wrote:
> On Fri, Jun 27, 2014 at 04:34:35PM +0200, jgross@suse.com wrote:
>> From: Juergen Gross <jgross@suse.com>
>>
>> Introduces the XEN pvSCSI backend. With pvSCSI it is possible for a XEN domU
>> to issue SCSI commands to a SCSI LUN assigned to that domU. The SCSI commands
>> are passed to the pvSCSI backend in a driver domain (usually Dom0) which is
>> owner of the physical device. This allows e.g. to use SCSI tape drives in a
>> XEN domU.
>
> This should be written against the generic target core infrastructure
> in drivers/target, instead of introducing another simplistic pass
> through only SCSI target.
> .
>

Just to be sure: you mean something like a combined version of
tcm_vhost and virtio_scsi?


Juergen
