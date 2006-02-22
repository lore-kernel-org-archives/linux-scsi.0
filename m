From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] fc transport: Add support for events
Date: Wed, 22 Feb 2006 10:01:53 -0800
Message-ID: <20060222180153.GB433@us.ibm.com>
References: <43FC8CB4.2000507@emulex.com> <20060222172127.GA20137@infradead.org> <43FCA2CF.6080903@emulex.com> <20060222174533.GA20794@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:8937 "EHLO e31.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1161168AbWBVSHA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Feb 2006 13:07:00 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e31.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k1MI6tRQ012681
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 13:06:55 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k1MI4VjN258212
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 11:04:31 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k1MI6sWg015677
	for <linux-scsi@vger.kernel.org>; Wed, 22 Feb 2006 11:06:55 -0700
Content-Disposition: inline
In-Reply-To: <20060222174533.GA20794@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Smart <James.Smart@Emulex.Com>, linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Feb 22, 2006 at 12:43:43PM -0500, James Smart wrote:
> > It would have been nice to have had this response on the RFC.
> > 
> > I'm actually looking into netlink for the CT pass thru, ELS and rnid
> > functions.
> > 
> > Does it make sense to move forward with some event support - namely
> > the events attributes minus the kobject_uevent() stuff ?
> 
> Actually the events attributes are what I don't like at all.  kobject_uevent
> already is a wrapper around netlink, it just doesn't allow to transport
> all the nessecary data.
> 

The scsi_transport_iscsi.c already contains the netlink infrastructure.
Maybe some of this code could be shared between the transports.

I derived another implementation off the iscsi transport code for dm that
uses the netlink attribute support.
https://www.redhat.com/archives/dm-devel/2006-February/msg00024.html

-andmike
--
Michael Anderson
andmike@us.ibm.com
