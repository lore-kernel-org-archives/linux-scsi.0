From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: [RFC] embryonic RAID class
Date: Thu, 18 Aug 2005 07:44:06 -0500
Message-ID: <20050818124406.GA13687@lists.us.dell.com>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01709318@otce2k03.adaptec.com> <1124318725.5221.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:38724 "EHLO
	ausc60pc101.us.dell.com") by vger.kernel.org with ESMTP
	id S932204AbVHRMoH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Aug 2005 08:44:07 -0400
Content-Disposition: inline
In-Reply-To: <1124318725.5221.12.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Aug 17, 2005 at 06:45:25PM -0400, James Bottomley wrote:
> > Add hotspare-0, hotspare-1 ... to the list?
> 
> Yes ... I only have two disks though, so I've reached the limit of what
> I can do with my current fusion setup.  The whole of the component
> display has to be reworked anyway (I only provide add, but obviously
> delete should be allowed as well as component type).  I'll add it to the
> list.  Probably we also need a component state model as well (and
> perhaps spare would be one of the states).

Different controllers have different hot spare capabilities.  Some hot
spares are global to the whole array and can fill in if any disk
fails.  Others are tied to either a group of logical volumes, or to a
single logical volume.  The first and third associations are easy, the
second association will require a new group concept.

Thanks,
Matt

-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
