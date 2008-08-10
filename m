From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH 1/4] scsi: megaraid_sas - Add the dumy readl to force
	PCI flush
Date: Sun, 10 Aug 2008 10:03:36 -0500
Message-ID: <1218380616.3418.23.camel@localhost.localdomain>
References: <FFD04EB4FBD32E4B929B6CFDEDA6AA0D632A9F@NAMAIL1.ad.lsil.com>
	 <4B6A08C587958942AA3002690DD4F8C31B08093F@cosmail02.lsi.com>
	 ,<20080804174128.a0877c27.akpm@linux-foundation.org>
	 <4B6A08C587958942AA3002690DD4F8C31AADD4C1@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55828 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511AbYHJPDm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Aug 2008 11:03:42 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C31AADD4C1@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@linuxfoundation.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "Patro, Sumant" <Sumant.Patro@lsi.com>, "Austria, Winston" <Winston.Austria@lsi.com>, "poswald@novell.com" <poswald@novell.com>

On Tue, 2008-08-05 at 06:27 -0600, Yang, Bo wrote:
> Thanks Andrew.

So could we have the corrected patch, please ... at least the pci
posting flush fix looks like a pure bug fix that's a rc candidate.

James


