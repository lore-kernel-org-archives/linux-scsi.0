From: Christian Roessner <info@roessner-net.com>
Subject: Re: tmscsim broken on amd64 with 2.6.5?
Date: Tue, 13 Apr 2004 22:17:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200404132217.25388.info@roessner-net.com>
References: <Pine.LNX.4.44.0404131911110.4021-200000@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p15112047.pureserver.info ([217.160.169.118]:30162 "EHLO
	mail.wim-media.de") by vger.kernel.org with ESMTP id S263730AbUDMURL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 16:17:11 -0400
In-Reply-To: <Pine.LNX.4.44.0404131911110.4021-200000@poirot.grange>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-scsi@vger.kernel.org

Hi,

great! Problem fixed. cdrecord -scanbus show my TEAC 512 
writer. /proc/scsi/tmscsim/5 shows sync-speed 5.0M. Fine!

Can I remove the debugging statements?

Regards

Christian
