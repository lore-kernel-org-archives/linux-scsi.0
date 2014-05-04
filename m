From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND] scsi_transport_sas: move bsg destructor into
 sas_rphy_remove
Date: Sun, 04 May 2014 12:11:54 -0700
Message-ID: <1399230714.2171.47.camel@dabdike.int.hansenpartnership.com>
References: <1396471241-1315-1-git-send-email-joe.lawrence@stratus.com>
	 <20140402164852.1f20ccb6@jlaw-desktop.mno.stratus.com>
	 <20140502150132.6ddd8a0c@jlaw-desktop.mno.stratus.com>
	 <CAPcyv4jcD9RG9B4vjcE8227Yx09j3v+OPNxhE58ZbFo2202mnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51766 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751851AbaEDTLz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2014 15:11:55 -0400
In-Reply-To: <CAPcyv4jcD9RG9B4vjcE8227Yx09j3v+OPNxhE58ZbFo2202mnA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>

On Fri, 2014-05-02 at 12:26 -0700, Dan Williams wrote:
> On Fri, May 2, 2014 at 12:01 PM, Joe Lawrence <joe.lawrence@stratus.com> wrote:
> > On Wed, 2 Apr 2014 16:48:52 -0400
> > Joe Lawrence <joe.lawrence@stratus.com> wrote:
> >
> >> On Wed, 2 Apr 2014 16:40:41 -0400
> >> Joe Lawrence <joe.lawrence@stratus.com> wrote:
> >>
> >> > Since bsg creation is a side effect of sas_rphy_add, move its
> >> > complementary removal call into sas_rphy_remove.
> >>
> >> Hello James,
> >>
> >> This a resend of a patch posted to quiet an end-device sysfs warning in
> >> its device deletion path when removing the mpt2sas driver:
> >>
> >>   (initial report)
> >>   sysfs group not found for kobject on mpt2sas unload
> >>   http://marc.info/?t=138497460000004
> >>
> >>   (patch + ACK + comments)
> >>   http://marc.info/?t=138609455500001
> >>
> >>   (gentoo, LSI repro)
> >>   mpt2sas driver barfs when force removing a drive on 3.13.1
> >>   http://marc.info/?t=139122351300001
> >>
> >> Dan Williams had a few other suggestions for cleanup in this area, but
> >> those could be handled in a subsequent patch.  This one missed 3.14
> >> inclusion and the warning still occurs in Linus's tree as of today
> >> (post scsi/block merge) hence the repost.
> >
> > Ping? Just reproduced on 3.15-rc3.  Also found this:
> >
> >   (~500 repro count on Fedora Problem Tracker)
> >   http://retrace.fedoraproject.org/faf/problems/1623421/
> >
> 
> Hmm, looks like the re-send is missing my ack.  Feel free to add:
> 
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> 
> James, do you want me to shepherd sas infrastructure bits
> (libsas/scsi_transport_sas) along in my own tree, or...?

Well, let's try a tree for enhancements ... you know the drill: signed
pull to me on or before -rc6.

This one, based on the fedora tracker info (only just shown) looks like
a bug affecting older kernels, so necessitating a cc to stable, right?
I'll take it through scsi-fixes

James


