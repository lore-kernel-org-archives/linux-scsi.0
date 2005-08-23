From: James.Smart@Emulex.Com
Subject: RE: [PATCH] minimal SAS transport class
Date: Tue, 23 Aug 2005 14:25:49 -0400
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C20F447E@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:53171 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932213AbVHWS0S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2005 14:26:18 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: luben_tuikov@adaptec.com, hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

> I thought by "the target id is logical for everything but 
> SPI" you meant
> that FC enumerated the scsi_device id.

Yes, I meant that.

> I didn't mean to address problems with persistent names, just map the
> scsi_device id to an FC value.

True. Port ID is just a bad example. Unfortunately, there's nothing in
FC, outside of wwpn (and sometimes wwnn), that you can uniquely identify
a device by. Since the wwpn didn't fit in the scsi_device id, it mandated
a translation to something that did. A simple sequential counter was
chosen. To keep things consistent, and done in a LLDD-independent manner,
the FC transport owned the assignment of the counter and the persistency
(and consistency) of the mapping.

-- james
