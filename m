From: "Heinz, Michael" <mheinz@infiniconsys.com>
Subject: HBA switching devices online status...
Date: Mon, 15 Apr 2002 11:54:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <08628CA53C6CBA4ABAFB9E808A5214CB0C4D1F@mercury.infiniconsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

If the SCSI midlayer flags a device as offline due to errors, is there
any way to restore the device once the errors have been resolved?

I'm interested in either manual or automatic (i.e., in the driver)
solutions. Looking through the source for different HBAs I didn't see
any obvious hints.

--
Now, where is that clue? I know I had one a minute ago....
--
mheinz@infiniconsys.com


