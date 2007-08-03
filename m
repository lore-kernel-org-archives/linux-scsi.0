From: Rob Landley <rob@landley.net>
Subject: Re: Some quick scsi documentation questions:
Date: Thu, 2 Aug 2007 21:12:16 -0400
Message-ID: <200708022112.16298.rob@landley.net>
References: <200707252328.28981.rob@landley.net> <46B2256A.3070902@torque.net> <46B24F2B.2060905@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:42716
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754617AbXHCBMU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2007 21:12:20 -0400
In-Reply-To: <46B24F2B.2060905@s5r6.in-berlin.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: dougg@torque.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Thursday 02 August 2007 5:39:55 pm Stefan Richter wrote:
> The place where these symlinks live might change in the future.  See
> linux-2.6.23*/Documentation/sysfs-rules.txt.

I noticed this.  I had a longish flamewar with Greg KH about this, which would 
be ongoing if he hadn't stopped replying.

It's easy to find out information like this by experimenting with sysfs.  And 
then they change it in future versions, and blame the user for using what 
sysfs exports.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
