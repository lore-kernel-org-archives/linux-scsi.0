From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Some quick scsi documentation questions:
Date: Fri, 03 Aug 2007 10:15:27 +0200
Message-ID: <46B2E41F.7090705@s5r6.in-berlin.de>
References: <200707252328.28981.rob@landley.net> <46B2256A.3070902@torque.net> <46B24F2B.2060905@s5r6.in-berlin.de> <200708022112.16298.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:50274 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbXHCIP3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2007 04:15:29 -0400
In-Reply-To: <200708022112.16298.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: dougg@torque.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Rob Landley wrote:
> On Thursday 02 August 2007 5:39:55 pm Stefan Richter wrote:
>> The place where these symlinks live might change in the future.  See
>> linux-2.6.23*/Documentation/sysfs-rules.txt.
> 
> I noticed this.  I had a longish flamewar with Greg KH about this, which would 
> be ongoing if he hadn't stopped replying.
> 
> It's easy to find out information like this by experimenting with sysfs.  And 
> then they change it in future versions, and blame the user for using what 
> sysfs exports.

Sysfs lets you peek into kernel implementation details.  Hence what you
see in sysfs will change all the time when the implementation is
changed.  It's important to realize this before making use of sysfs.

Sysfs (most of it) is not a stable ABI.  Never has been, never will be,
never was intended to be.  That's overlooked again and again.

If you want to do something that requires a stable ABI between kernel
and userspace, then use such a stable ABI (including the small parts of
sysfs that have been declared stable and hence will remain stable).
-- 
Stefan Richter
-=====-=-=== =--- ---==
http://arcgraph.de/sr/
