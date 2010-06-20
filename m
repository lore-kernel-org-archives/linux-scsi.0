From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I:
 Enable Online Controller Reset Bit in register related functions
Date: Sun, 20 Jun 2010 14:47:30 -0500
Message-ID: <1277063250.5242.25.camel@mulgrave.site>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
	 <AANLkTikM_rCfKKUd9vokhBi_YWg5qIPRKsnfiQiluFwl@mail.gmail.com>
	 <1277046060.5242.18.camel@mulgrave.site>
	 <4B6A08C587958942AA3002690DD4F8C3D09275CC@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756927Ab0FTTri (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jun 2010 15:47:38 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3D09275CC@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Sun, 2010-06-20 at 13:27 -0600, Yang, Bo wrote:
> The online controller reset (OCR) need to apply [Patch 1/12  --  patch
> 8/12].  I already submitted all of them.

So 1-8 have to be done as a single commit and 9-12 can apply
individually?

James


