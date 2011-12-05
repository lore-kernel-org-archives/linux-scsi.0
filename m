From: "Sampathkumar, Kishore" <Kishore.SampathKumar@lsi.com>
Subject: Unique numeric ID for SCSI-3 disks
Date: Mon, 5 Dec 2011 14:03:07 +0530
Message-ID: <E4D7778E36CF944ABD2F7E18D2DB9666271BAC7FBF@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:56536 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602Ab1LEIdO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Dec 2011 03:33:14 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

In SCSI-3 SPC, I was going through the section on "Device Identification VPD Page" (Section 7.6.3). I see the following:

If "Association" field in VPD83 page is set to 00b (i.e., The IDENTIFIER field is associated with the addressed logical unit), the above standard says:

At least one identification descriptor should have the IDENTIFIER TYPE field set to:
a) 2h (i.e., EUI-64-based);
b) 3h (i.e., NAA); or
c) 8h (i.e., SCSI name string).

Going through the details of (a) and (b), I notice that they are numeric.

However, (c) above is an ASCII string. But, even in this case, if the first 4 UTF-8 characters are parsed, the rest of it contains numeric value in ASCII.

For all SCSI disks that are SCSI-3 SPC compliant, for the above case, is it safe to say: each of them shall have an associated "numeric value" that is "unique" (assuming that the 4 UTF-8 characters for "SCSI name string" format are stored/available).

Thanks,
-Kishore
