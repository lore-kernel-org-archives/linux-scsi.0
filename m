From: adam radford <aradford@gmail.com>
Subject: Re: [PATCH 7/11]: megaraid_sas: Add MegaRAID 9265/9285 specific
 functions: megaraid_sas_fusion.c
Date: Fri, 17 Dec 2010 09:46:16 -0800
Message-ID: <AANLkTin6DGkRw+392=xoQbrD1c2S2DN9CG4DuaYwfqJ8@mail.gmail.com>
References: <AANLkTik1KwdG+73gWCqGj7sROdxWfBYfKqH4t=rcQkhi@mail.gmail.com>
	<4D0A1AD0.1040703@redhat.com>
	<AANLkTikEB02WAiHTYe=FLm9EKhjTdaLLd97NQvWg2Y9t@mail.gmail.com>
	<AANLkTin5=YL2mQxtGKQUTRCvnb2N29B32+J2ds8t-xPP@mail.gmail.com>
	<4D0B3E9F.5000101@redhat.com>
	<1292591611.2820.1.camel@mulgrave.site>
	<AANLkTinHvfTvh6vJukMjc2nD=VWOedL1MhK9KW1z4qK_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:40498 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754570Ab0LQRqS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Dec 2010 12:46:18 -0500
Received: by qwa26 with SMTP id 26so937184qwa.19
        for <linux-scsi@vger.kernel.org>; Fri, 17 Dec 2010 09:46:17 -0800 (PST)
In-Reply-To: <AANLkTinHvfTvh6vJukMjc2nD=VWOedL1MhK9KW1z4qK_@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Tomas Henzl <thenzl@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

On Fri, Dec 17, 2010 at 9:30 AM, adam radford <aradford@gmail.com> wrote:
> On Fri, Dec 17, 2010 at 5:13 AM, James Bottomley
> <James.Bottomley@suse.de> wrote:
>>
>> What I do want for this is a rolled up change log for the entire commit,
>> please.
>>
>
> James,
>
> What exactly are you looking for here that I didn't provide in the
> description summary in patch 0/11 ?
>
> -Adam
>

James,

Here is a changelog for the commit of patches 6 thru 10:

Add MegaRAID 9265/9285 specific code to megaraid_sas_base.c.
Add MegaRAID 9265/9285 specific functions: megaraid_sas_fusion.c.
Add MegaRAID 9265/9285 megaraid_sas_fusion.h header.
Add MegaRAID 9265/9285 FastPath code.
Add MegaRAID 9265/9285 specific code to megaraid_sas.h.

-Adam
