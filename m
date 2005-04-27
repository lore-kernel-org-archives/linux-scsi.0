From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [RFC] SAS domain layout for Linux sysfs
Date: Wed, 27 Apr 2005 11:38:33 -0400
Message-ID: <426FB1F9.9010401@adaptec.com>
References: <425D392F.2080702@adaptec.com> <20050424111908.GA23010@infradead.org> <426D1572.70508@adaptec.com> <20050425161411.GA11938@infradead.org> <426D2723.8070308@adaptec.com> <20050425181831.GA14190@infradead.org> <426E5BAF.4040003@adaptec.com> <426F86D3.4070909@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:56794 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261627AbVD0Pig (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2005 11:38:36 -0400
In-Reply-To: <426F86D3.4070909@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, andrew.patterson@hp.com, Eric.Moore@lsil.com, mike.miller@hp.com, Madhuresh_Nagshain@adaptec.com

On 04/27/05 08:34, Douglas Gilbert wrote:
> Once the SAS discovery algorithm has been run should we
> show its results in sysfs?? We probably want to know
> about SCSI target devices (like we do for other transports).
> The SAS discovery algorithm may have found other interesting
> things:
>     - other expanders (beyond what the silicon has seen)
>     - other initiators (implies a multi initiator environment)
>     - miswired SAS domains (since SAS expander routing rules
>       have restrictions)

Yes, I think we should know about those other devices, part
of SAS SDS.
 
> Other tools may want to access SMP (and SCSI log pages
> in SCSI target devices) to identify bottlenecks and access
> vendor extensions.

Yes, very true.  I can imagine user space apps sending SMP
and what not to expanders/RAID devices/enclosures past
expanders, to control the storage network.

A sysfs representation of the discovery result could make this
easy, since as you pointed out expanders are not SAS devices,
and thus do not fit the linux-scsi HCTL space.

	Luben
