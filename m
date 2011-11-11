From: "Mark Salyzyn" <mark_salyzyn@us.xyratex.com>
Subject: RE: aacraid controller hangs if kernel uses non-default ASPM policy
Date: Fri, 11 Nov 2011 06:20:30 -0800
Message-ID: <FC1F9E38C0703341A1A750524E2525A9018F95B1@XYUS-EX22.xyus.xyratex.com>
References: <4EBCEDED.7030907@parallels.com> <20111111130938.GA10242@srcf.ucam.org> <1321020913.5161.15.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex198.xyratex.com ([194.131.166.198]:35002 "EHLO
	XY01EX22.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751292Ab1KKOfN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2011 09:35:13 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1321020913.5161.15.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Vasily Averin <vvs@parallels.com>, linux-scsi@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@adaptec.com>

Aacraid is *not* out of production, there is just a long legacy of EOL'd
cards. PMC is continued developing and extending the hardware (Series 6
and beyond)

Sincerely -- Mark Salyzyn

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Friday, November 11, 2011 9:15 AM
To: Matthew Garrett
Cc: Vasily Averin; linux-scsi@vger.kernel.org; Adaptec OEM Raid
Solutions; Mark Salyzyn
Subject: Re: aacraid controller hangs if kernel uses non-default ASPM
policy

On Fri, 2011-11-11 at 13:09 +0000, Matthew Garrett wrote:
> Yeah, sorry about that, it's something that was on my list to deal
with. 
> Disabling ASPM entirely on aacraid really isn't a desirable outcome - 
> it'd be significantly better to identify which chipsets are broken
with 
> it enabled and then only disable those.

Well, aacraid is out of production, I believe, so lets fix the hang
first (with a global disable) and we can gradually re-enable if we get
experimenters who try it with particular HW.

James



