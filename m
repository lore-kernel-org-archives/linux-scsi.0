From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Some quick scsi documentation questions:
Date: Sat, 04 Aug 2007 02:35:46 +0200
Message-ID: <46B3C9E2.7090906@s5r6.in-berlin.de>
References: <200707252328.28981.rob@landley.net> <200708022055.45523.rob@landley.net> <46B306CD.3030002@s5r6.in-berlin.de> <200708031611.26768.rob@landley.net> <46B3C36F.8060405@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:52875 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910AbXHDAgJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2007 20:36:09 -0400
In-Reply-To: <46B3C36F.8060405@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: dougg@torque.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

> Did people point you already to http://www.t10.org/scsi-3.htm?
...
> Also have a look at the SAM-4 spec, figure 2.

PS:  See also SAM-4 annex A tables A.2 and A.3:  The concatenation of
target port identifier and logical unit identifier is one important way
to uniquely and persistently identify SCSI devices.  Linux' SCSI
transport layer implementations currently have no common way to expose
these identifiers to userspace though; the parts that make up these
identifiers are located in diverse sysfs attributes.
-- 
Stefan Richter
-=====-=-=== =--- --=--
http://arcgraph.de/sr/
