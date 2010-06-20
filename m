From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I:
 Enable Online Controller Reset Bit in register related functions
Date: Sun, 20 Jun 2010 09:54:31 -0500
Message-ID: <1277045671.5242.17.camel@mulgrave.site>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
	 <AANLkTikM_rCfKKUd9vokhBi_YWg5qIPRKsnfiQiluFwl@mail.gmail.com>
	 <4B6A08C587958942AA3002690DD4F8C3D09274C4@cosmail02.lsi.com>
	 <AANLkTilNX7_IDjw5lFYpkzlGGPHeRsswWZCXslw5GsjQ@mail.gmail.com>
	 <4B6A08C587958942AA3002690DD4F8C3D09274EA@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:37954 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114Ab0FTOyj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 20 Jun 2010 10:54:39 -0400
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3D09274EA@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: Yinghai Lu <yinghai@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "akpm@osdl.org" <akpm@osdl.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, 2010-06-18 at 15:56 -0600, Yang, Bo wrote:
> Thanks, Yinghai.  It is possible James didn't push (patches 5-12) yet.

Well, that was because of the compile failure.

However, we can't have a sequence of patches that hangs the controller
in the middle because, as has already been pointed out, that breaks
bisectability too.  It's just lacking the hardware, I can't check for
that particular problem.

What grouping do these 12 patches have to be applied in to get a working
controller in between them?

James


