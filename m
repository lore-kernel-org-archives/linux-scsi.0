From: "Nick Cheng" <nick.cheng@areca.com.tw>
Subject: RE: [PATCH 1/3 ] SCSI: Support HW reset for EH and polling scheme for scsi device(This is correct revision, please ignore last one)
Date: Mon, 3 May 2010 21:26:57 +0800
Message-ID: <B16CB7C307AA4AD0B4083BE7F6B2DAE1@areca4e4f859d4>
References: <5B75F1A9B45A486E8A44B035EDCC381E@areca4e4f859d4> <1272891585.4369.15.camel@mulgrave.site> <543391074648471F8A10624BAC48E286@areca4e4f859d4> <1272893071.4369.24.camel@mulgrave.site>
Reply-To: <nick.cheng@areca.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:61037 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759302Ab0ECN1K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2010 09:27:10 -0400
In-Reply-To: <1272893071.4369.24.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

It seems I have to remove this section first then make a new patch for you.
I will email the patches to you tomorrow.
Thanks,
-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@suse.de] 
Sent: Monday, May 03, 2010 9:25 PM
To: nick.cheng@areca.com.tw
Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: RE: [PATCH 1/3 ] SCSI: Support HW reset for EH and polling scheme
for scsi device(This is correct revision, please ignore last one)

On Mon, 2010-05-03 at 21:17 +0800, Nick Cheng wrote:
> Hi James,
> It seems you set CONFIG_SCSI_ARCMSR_AER.
> Could you undefine it?

Config option testing is part of the stuff I run through.  Even if I
undefine it, one of the many people who run automated config testing
will pick it up ... and then I'll get email about it.

> I will remove this section.

Thanks.

James


