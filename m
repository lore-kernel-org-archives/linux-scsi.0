From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 7/8] bfa: Fix crash when symb name set for offline vport
Date: Tue, 03 Dec 2013 06:42:01 -0800
Message-ID: <1386081721.2166.38.camel@dabdike.int.hansenpartnership.com>
References: <1384931146-3702-1-git-send-email-vmohan@brocade.com>
	 <1384931146-3702-8-git-send-email-vmohan@brocade.com>
	 <1386081181.2166.37.camel@dabdike.int.hansenpartnership.com>
	 <51BD2AE8016AE441B63F5661159C990248D762F810@BRM-EXCH-3.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51397 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752630Ab3LCOmD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Dec 2013 09:42:03 -0500
In-Reply-To: <51BD2AE8016AE441B63F5661159C990248D762F810@BRM-EXCH-3.corp.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vijaya Mohan Guvva <vmohan@Brocade.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Anil Gurumurthy <agurumur@Brocade.com>

On Tue, 2013-12-03 at 07:38 -0700, Vijaya Mohan Guvva wrote:
> > On Tue, 2013-11-19 at 23:05 -0800, vmohan@brocade.com wrote:
> > > From: Vijaya Mohan Guvva <vmohan@brocade.com>
> > >
> > > This patch fixes a crash when tried setting symbolic name for an
> > > offline vport through sysfs. Crash is due to uninitialized pointer
> > > lport->ns, which gets initialized only on linkup (port online).
> > 
> > This looks like a separable patch that should go through the fixes tree to
> > stable, is that right?
> > 
> > James
> > 
> 
> Hi James,
> Yes, this is a bug fix and should go through the fixes tree to stable tree.
> So, should I separate this patch from the original patch and submit it separately?

No, that's OK this time around, I can cut this out of the set.  Next
time, having separate bug fixes and updates allows this to happen
without me having to ask.

James


