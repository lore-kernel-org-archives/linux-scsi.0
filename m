From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aic79xx problems
Date: Thu, 20 Sep 2007 09:15:51 -0500
Message-ID: <1190297751.3360.15.camel@localhost.localdomain>
References: <20070920130440.GE1606@loop.mdy.univie.ac.at>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:36077 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753004AbXITOPx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 10:15:53 -0400
In-Reply-To: <20070920130440.GE1606@loop.mdy.univie.ac.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Boresch <stefan@mdy.univie.ac.at>
Cc: linux-scsi@vger.kernel.org

On Thu, 2007-09-20 at 15:04 +0200, Stefan Boresch wrote:
> I could live with all this if kernels 2.6.2x I have tried would not
> simply crash.  When the aic79xx module loads, I get again endless
> 
> >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
> 
> listings, but the warnings / error messages get more and more severe
> until the system hangs.


This shouldn't be happening; we should get the same behaviour as the old
kernels (lots of scary warnings and problems but then turn off wide and
continue on).  Investigating this, unfortunately, is going to be a real
pain.  However, I think I can cut a cable to simulate your problem.

James


