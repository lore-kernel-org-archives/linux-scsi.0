From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] aic94xx: driver assertion in non-x86 BIOS env
Date: Wed, 01 Mar 2006 15:22:42 -0500
Message-ID: <44060292.5020309@pobox.com>
References: <8C064C48AB104B428CBA524C342357CA324AE4@aime2k05.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:39907 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1750790AbWCAUWr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2006 15:22:47 -0500
In-Reply-To: <8C064C48AB104B428CBA524C342357CA324AE4@aime2k05.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Tarte, Robert" <Robert_Tarte@adaptec.com>
Cc: Mike Anderson <andmike@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Tarte@us.ibm.com, Jeff Garzik <jgarzik@redhat.com>

Tarte, Robert wrote:
> What model ia64 are you running James?  I'll see if Adaptec has one to
> try to help reproduce this issue.  Jeff, have you tried the fixes to see
> if they addressed the issues you were seeing (OCM error when BIOS off
> and booted off of SCSI)?

Nah, I'm just waiting for James to ACK that things work on his side, 
really...

	Jeff



