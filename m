From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [PATCH 1/1] scsi: megaraid_sas - Fix random failure of DCDB cmds with sense info
Date: Fri, 22 Feb 2008 09:17:33 -0700
Message-ID: <9738BCBE884FDB42801FAD8A7769C26501F6979B@NAMAIL1.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:50620 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080AbYBVQST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Feb 2008 11:18:19 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>, "Kolli, Neela" <Neela.Kolli@lsi.com>

James,

What is the status for this patch?  We need to submit more patches based
on the acceptance of this patch.

Thanks.

Bo Yang 

-----Original Message-----
From: Yang, Bo 
Sent: Thursday, November 29, 2007 1:24 PM
To: 'Matthew Wilcox'
Cc: linux-scsi@vger.kernel.org; James.Bottomley@SteelEye.com;
akpm@osdl.org; linux-kernel@vger.kernel.org; Patro, Sumant; Kolli, Neela
Subject: RE: [PATCH 1/1] scsi: megaraid_sas - Fix random failure of DCDB
cmds with sense info


Matthew,

I think my last email confused you. Here are the points for submitting
this patch:

1. It is only to add the ia64 support to our driver.  This is why we add
the ia64 flag.

2. We did not change the implementation for x86 and x86_64.  The
implementation for them with u32 * is there from day one.

3. What I wanted to convey in my previous mail is that if one uses a 64
bit application (s)he may need to test for all functionality again.	

Regards.

Bo Yang

-----Original Message-----
From: Matthew Wilcox [mailto:matthew@wil.cx]
Sent: Wednesday, November 28, 2007 2:27 PM
To: Yang, Bo
Cc: linux-scsi@vger.kernel.org; James.Bottomley@SteelEye.com;
akpm@osdl.org; linux-kernel@vger.kernel.org; Patro, Sumant; Kolli, Neela
Subject: Re: [PATCH 1/1] scsi: megaraid_sas - Fix random failure of DCDB
cmds with sense info

On Wed, Nov 28, 2007 at 12:08:37PM -0700, Yang, Bo wrote:
> Matthew,
> 
> Yes, as I mentioned, our applications are built in 32-bit environment 
> (except for ia64).
> We may see a different behavior if we build it in 64-bit for x86-64. 

Then this patch isn't acceptable.  You need to find a way which works
for both 32-bit and 64-bit applications.

--
Intel are signing my paycheques ... these opinions are still mine "Bill,
look, we understand that you're interested in selling us this operating
system, but compare it to ours.  We can't possibly take such a
retrograde step."
