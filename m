From: Christoph Hellwig <hch@lst.de>
Subject: HEADS UP for gdth driver users
Date: Wed, 8 Mar 2006 14:19:48 +0100
Message-ID: <20060308131948.GA4755@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751409AbWCHNT6@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, achim_leubner@adaptec.com
List-Id: linux-scsi@vger.kernel.org

Hi folks,

the gdth driver is the only driver using (and in this case abusing) the
scsi_request interface we plan to kill for 2.6.17.  I've sent a patch
that's a first step to convert the driver away from it a few weeks ago
but didn't get any response.  I urgently need testers to keep the driver
for 2.6.17+.  Else it'll be marked broken until we get a person to help
testing the changes needed to resurrect it.
