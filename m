From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [RESEND PATCH] mptsas: Fixed code to check whether the LU type
 is SSC or not for SILI bit in READ_6 and READ_16 CDB
Date: Thu, 29 Mar 2012 08:51:50 +0100
Message-ID: <1333007510.2823.7.camel@dabdike>
References: <201203060645.q266jR8Y026994@milmhbs0.lsil.com>
	 <1331081000.3226.37.camel@dabdike.int.hansenpartnership.com>
	 <A6888A6805518E4EA4AF7072A28264A6067E6736F1@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44148 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738Ab2C2Hvx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Mar 2012 03:51:53 -0400
In-Reply-To: <A6888A6805518E4EA4AF7072A28264A6067E6736F1@inbmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2012-03-07 at 15:04 +0530, Nandigama, Nagalakshmi wrote:
> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
> Sent: Wednesday, March 07, 2012 6:13 AM
> To: Nandigama, Nagalakshmi
> Cc: stable@vger.kernel.org; linux-scsi
> Subject: Re: [RESEND PATCH] mptsas: Fixed code to check whether the LU type is SSC or not for SILI bit in READ_6 and READ_16 CDB
> 
> On Tue, 2012-03-06 at 12:16 +0530, nagalakshmi.nandigama@lsi.com wrote:
> >> This SILI bit (suppress incorrect length indicator) is defined only for SSC
> >> READ(6) and READ(16) commands. For other device types bit is part of LBA
> 
> >This isn't right ... it is for READ(6) but it's FUA_NV for
> >READ(10,12,16) on block devices.
> 
> 
> For READ6, READ16 SSC commands, the BIT 1of BYTE 2 is SILI. (As per SSC4 specs)
> For block commands, the BIT 1of BYTE 2 is part of LBA for READ6 and FUA_NV bit for 
> READ(10,12,16).
> 
> So it is required to check whether the logical unit is SSC device or not when checking SILI bit.
> So in the patch which I sent, I added this piece of code.

That's what the standards say, yes, I know that.  If there's a visible
bug, this is the description of the cause.  What I'm asking is what is
the actual user visible effect?  The change log needs to include that to
give people who read it an idea of why they might need to apply the fix.

James
 

