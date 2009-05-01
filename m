From: "Abhijeet Arvind Joglekar (abjoglek)" <abjoglek@cisco.com>
Subject: RE: [PATCH] libfc,fcoe,fnic: Separate rport and lport max retrycounts
Date: Fri, 1 May 2009 10:12:57 -0700
Message-ID: <9E88C8678BF34240A8C61D4078A3D251010B08FB@xmb-sjc-23e.amer.cisco.com>
References: <20090501165111.16733.31537.stgit@feynman.nuovasystems.com> <1241197721.3302.35.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:42616 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764711AbZEARM7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2009 13:12:59 -0400
Content-class: urn:content-classes:message
In-reply-to: <1241197721.3302.35.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, robert.w.love@intel.com

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
> Sent: Friday, May 01, 2009 10:09 AM
> To: Abhijeet Arvind Joglekar (abjoglek)
> Cc: linux-scsi@vger.kernel.org; robert.w.love@intel.com
> Subject: Re: [PATCH] libfc,fcoe,fnic: Separate rport and 
> lport max retrycounts
> 
> On Fri, 2009-05-01 at 10:01 -0700, Abhijeet Joglekar wrote:
> > This patch is a minor update to the libfc/fcoe/fnic 
> drivers. It adds a 
> > separate knob to libFC to allow the lower-level driver 
> (fnic or fcoe) 
> > to configure the number of retries for lport and rport separately.
> > 
> > Its not a bug fix, so it didnt get submitted along with Robert's 
> > previous set of libFC fixes for -rc4. Since its needed for fnic, 
> > maybe, it can go along with the fnic changes in scsi-misc. 
> Will that work?
> 
> Sure, but I thought you wanted fnic in -rc-fixes for 2.6.30?
> 
> James

Oops, I meant along with fnic when you pick it in -rc-fixes for 2.6.30.

thanks
-- abhijeet
