From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [SCSI] fix media change events for polled devices
Date: Fri, 21 Mar 2008 10:31:39 -0700 (PDT)
Message-ID: <alpine.LFD.1.00.0803211031010.3020@woody.linux-foundation.org>
References: <200803211559.m2LFxPi6017869@hera.kernel.org> <47E3EC67.4050404@garzik.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39897 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753185AbYCURcT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Mar 2008 13:32:19 -0400
In-Reply-To: <47E3EC67.4050404@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org



On Fri, 21 Mar 2008, Jeff Garzik wrote:
> 
> And that is the fix -- initialize supported_events according to sr/sd's needs,
> and revert this change (4d1566ed2100d074ccc654e5cf2e44cdea3a01d0) as obviously
> broken.

Patches, please? I can do the revert, but the patch to supported_events 
and the testing, please?

		Linus
