From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH V3 0/5] Drivers: scsi: storvsc
Date: Thu, 27 Jun 2013 03:39:09 +0000
Message-ID: <1372304349.557.15.camel@dabdike>
References: <1370372674-10046-1-git-send-email-kys@microsoft.com>
	 <ba5d1c4a36a441f09e6a1c5aa4e6d6a3@SN2PR03MB061.namprd03.prod.outlook.com>
	  <868094fd01274f3c89ef2a27e9e42a3d@SN2PR03MB061.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:56087 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3F0DjM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jun 2013 23:39:12 -0400
In-Reply-To: <868094fd01274f3c89ef2a27e9e42a3d@SN2PR03MB061.namprd03.prod.outlook.com>
Content-Language: en-US
Content-ID: <5C48FB36522734478AD316E072A013D7@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2013-06-26 at 12:58 +0000, KY Srinivasan wrote:
> 
> > -----Original Message-----
> > From: KY Srinivasan
> > Sent: Monday, June 17, 2013 9:32 AM
> > To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; ohering@suse.com; jbottomley@parallels.com;
> > hch@infradead.org; linux-scsi@vger.kernel.org
> > Subject: RE: [PATCH V3 0/5] Drivers: scsi: storvsc
> > 
> > 
> > 
> > > -----Original Message-----
> > > From: KY Srinivasan
> > > Sent: Tuesday, June 11, 2013 9:02 AM
> > > To: KY Srinivasan; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > devel@linuxdriverproject.org; ohering@suse.com; jbottomley@parallels.com;
> > > hch@infradead.org; linux-scsi@vger.kernel.org
> > > Subject: RE: [PATCH V3 0/5] Drivers: scsi: storvsc
> > >
> > >
> > >
> > > > -----Original Message-----
> > > > From: K. Y. Srinivasan [mailto:kys@microsoft.com]
> > > > Sent: Tuesday, June 04, 2013 3:05 PM
> > > > To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> > > > devel@linuxdriverproject.org; ohering@suse.com;
> > jbottomley@parallels.com;
> > > > hch@infradead.org; linux-scsi@vger.kernel.org
> > > > Cc: KY Srinivasan
> > > > Subject: [PATCH V3 0/5] Drivers: scsi: storvsc
> > > >
> > > > This set adds multi-channel support as well synthetic Fibre Channel support
> > > > to storvsc. The multi-channel support depends on infrastructure in the
> > VMBUS
> > > > driver. Greg has already checked in the relevant patches to VMBUS.
> > > >
> > > > I had posted an earlier version of this patch-set that included the VMBUS
> > > > related changes. I have since separated the VMBUS chages and these have
> > > > already been
> > > > checked in.
> > > >
> > > > In this version, based on comments from James, the timeout is no longer a
> > > > module
> > > > parameter.
> > >
> > > James,
> > >
> > > I think I have addressed all the comments that you had; if not, please let me
> > > know.
> > 
> > Ping.
> 
> James,
> 
> Let me know if I should re-send the patches.

Just FYI, my workflow involves using imap flags to tag stuff for actions
and then using a set of date sorted evolution search folders to
translate the flags into work queues.  The search folders are by flag
and thread, so a side effect of the way evolution does date ordering is
that it's ordered by the most recent last, so the date it takes for
thread ordering is the most recent email in the thread.  Originally, I
thought of this as an annyoing evolution bug because I wanted the folder
ordered by date of the patch submission.  However, later I came to
appreciate that it meant currently actively discussed patches moved down
in my workqueue automatically, so now I quite like it as a feature. It
does mean, however, that the net effect of sending very frequent pings
about a patch set is to cause that patch set to move down in my work
queue and, unfortunately, even coming from a domain that habitually
breaks threading doesn't save you because evolution helpfully has a set
of heuristic rules to rethread outlook breakage.

James

