From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [AACRAID] Do not describe check_reset parameter with
	its value
Date: Wed, 16 Apr 2008 09:39:17 -0500
Message-ID: <1208356757.3227.9.camel@localhost.localdomain>
References: <1208334879.5614.34.camel@compaq.thuisdomein>
	 <7151509B-739F-4568-8C0C-2240C8561B6B@adaptec.com>
	 <1208349780.5614.64.camel@compaq.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36860 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752329AbYDPOjV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Apr 2008 10:39:21 -0400
In-Reply-To: <1208349780.5614.64.camel@compaq.thuisdomein>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mark Salyzyn <Mark_Salyzyn@adaptec.com>, Linux-Scsi <linux-scsi@vger.kernel.org>

On Wed, 2008-04-16 at 14:43 +0200, Paul Bolle wrote:
> From: Paul Bolle <pebolle@tiscali.nl>
> 
> Do not describe check_reset parameter with its value
>     
> Describe check_reset parameter with its name (and not its value)

OK, added this, thanks.  There's one slight problem I corrected:

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> Signed-off-by: Mark Salyzyn <Mark_Salyzyn@adaptec.com>

This should be Acked-by not Signed-off-by.

The rules are that Signed-off-by tracks the provenance of a patch (where
it came from).  So if you send the patch to Mark and he sends it to me,
it would have his Signed-off-by because it went through his hands (and
his tree).  If Mark acks the patch, but you send it to me, then it gets
an acked-by because it didn't actually pass through his hands.

James


