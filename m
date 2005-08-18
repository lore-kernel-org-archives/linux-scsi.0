From: James.Smart@Emulex.Com
Subject: RE: [PATCH] minimal SAS transport class
Date: Thu, 18 Aug 2005 10:43:27 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F442B@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:4572 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S932236AbVHROnm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Aug 2005 10:43:42 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com, hch@lst.de, jejb@steeleye.com
Cc: ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

One more thing missing...

As there is a transport object between the scsi_host and scsi_target,
the transport needs to pick up the changes made to deal with scans
made outside of the transport (after a scsi_target has been removed).

The fix that got merged into the scsi-misc tree can be seen at:
http://www.kernel.org/pub/linux/kernel/people/jejb/scsi-rc-fixes-2.6.changelog
http://www.kernel.org/pub/linux/kernel/people/jejb/scsi-rc-fixes-2.6.diff

and correspond to the patch at:
http://marc.theaimsgroup.com/?l=linux-scsi&m=111845669410785&w=2

-- james s

