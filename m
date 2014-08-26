From: David Vrabel <david.vrabel@citrix.com>
Subject: Re: [Xen-devel] [PATCH V5 0/5] Add XEN pvSCSI support
Date: Tue, 26 Aug 2014 11:13:15 +0100
Message-ID: <53FC5DBB.9080101@citrix.com>
References: <1408354310-6362-1-git-send-email-jgross@suse.com> <1408742515.24496.21.camel@haakon3.risingtidesystems.com> <20140823004042.GA5547@laptop.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.citrix.com ([66.165.176.89]:18983 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934467AbaHZKNT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2014 06:13:19 -0400
In-Reply-To: <20140823004042.GA5547@laptop.dumpdata.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: jgross@suse.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, JBeulich@suse.com

On 23/08/14 01:40, Konrad Rzeszutek Wilk wrote:
> On Fri, Aug 22, 2014 at 02:21:55PM -0700, Nicholas A. Bellinger wrote:
>> 
>>
>> For the XEN scsiback parts as a new target fabric driver, feel free to
>> add my:
>>
>> Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>
>>
>> So I assume this will be merged for v3.18 via the xen.git tree, yes..?

My preference is for drivers outside of drivers/xen/ to be merged via
their relevant subsystem tree.  This is how all the other Xen PV drivers
are handled (net, block, console, etc.).

> <nods>
> When I chatted with Christopher Hellwig he recommended it be done that way.

Did he give a reason?  The driver has more scsi bits in it than Xen bits
really.

David

