From: Asim Kadav <kadav@cs.wisc.edu>
Subject: Re: [PATCH] a100u2w: Added sanitization for pointer dereference using a value from hardware. Detected using Carburizer  (http://lwn.net/Articles/479653/)
Date: Fri, 28 Dec 2012 17:03:33 -0600
Message-ID: <898F3002-7027-4FE7-B34B-45943748EBB1@cs.wisc.edu>
References: <159925B4-EEAA-441E-8A8E-666DCA702D5B@cs.wisc.edu> <1356607503.2306.20.camel@dabdike> <E83641E5-24F4-493A-8D0C-347D8611FC75@cs.wisc.edu> <1356620014.2306.23.camel@dabdike>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58522 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab2L1XDg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Dec 2012 18:03:36 -0500
In-Reply-To: <1356620014.2306.23.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


> It's probably really not worth it.  The u100w2 is a pretty old SCSI
> driver.  I can't imagine there's more than a handful of them left.  As I
> said, there's no evidence of a problem.

I would argue that having hardened code is always better if you plan to
support this code at all. And these bugs manifest  more frequently as hardware 
gets older. Sanitizing inputs from hardware is a good idea and this one is 
particularly insidious since it uses it uses hardware values in pointer operations.

-Asim