From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 1/7] mpt2sas : Rescan topology from Interrupt context
 instead of work queue
Date: Fri, 14 Aug 2009 09:05:42 -0600
Message-ID: <660360F4F2570145BD872F298951B17AB2BA9CA4@cosmail03.lsi.com>
References: <1250261980.4021.7.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og107.obsmtp.com ([64.18.2.167]:52567 "EHLO
	exprod7og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570AbZHNPU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Aug 2009 11:20:58 -0400
In-Reply-To: <1250261980.4021.7.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Friday, August 14, 2009 9:00 AM,  James Bottomley wrote:

> Also, what exactly do these signoffs mean ... they're 
> supposed to track
> author and whose hands these patches have been through.  If Eric wrote
> them, and you're just submitting them, I need a From: field at the
> beginning to change the git authorship (and also the order of signoff
> needs reversing).
> 

I worked the fix back in May.   Kashyap is generating the patch's, and I'm reviewing them.

Eric Moore