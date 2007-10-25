From: Rob Landley <rob@landley.net>
Subject: What layer are "transport classes" in?
Date: Thu, 25 Oct 2007 17:13:56 -0500
Message-ID: <200710251713.56136.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:37785
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751500AbXJYVOL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 17:14:11 -0400
Received: from landley.net (localhost [127.0.0.1])
	by grelber.thyrsus.com (Postfix) with ESMTP id 91F887392C
	for <linux-scsi@vger.kernel.org>; Thu, 25 Oct 2007 17:16:50 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Looking at the scsi_transport_*.c files...  Are these part of the lower layer 
or the midlayer?  I _think_ these exist primarily to expose information about 
the lower layers through sysfs, but I'm very fuzzy on this...

Should they be documented as part of the lower layer or the midlayer or are 
they their own area...?

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
