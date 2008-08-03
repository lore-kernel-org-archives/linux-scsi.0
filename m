From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH 2/2] fusion:  Implement generic interrupt misroute
	handling
Date: Sun, 03 Aug 2008 18:07:44 -0500
Message-ID: <1217804865.4179.57.camel@localhost.localdomain>
References: <1217786709.4179.27.camel@localhost.localdomain>
	 <660360F4F2570145BD872F298951B17A3ADCEDB9@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42370 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758236AbYHCXHt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Aug 2008 19:07:49 -0400
In-Reply-To: <660360F4F2570145BD872F298951B17A3ADCEDB9@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Sun, 2008-08-03 at 16:59 -0600, Moore, Eric wrote:
> Thanks, I will try this out.   However I thought I saw lost interrupts
> occurring randomly, meaning it was not necessarily the first config
> page access.  I'm back in the office on 8/11, I will test it out then
> and provide feedback.

Well, this is the usual trouble.  I don't have a misbehaving
motherboard, so I artificially induce MSI problems on my platform.  For
me, it works, but obviously I'm losing every MSI interrupt.

James


