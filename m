From: James.Smart@Emulex.Com
Subject: RE: [PATCH 2/2  scsi-rc-fixes-2.6] FC Remote Port patch
Date: Wed, 9 Feb 2005 14:24:42 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C1FD1D9@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Received: from emulex.emulex.com ([138.239.112.1]:65485 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S261875AbVBITYw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Feb 2005 14:24:52 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org

> seems like sdev->shost is bogus when fc_remote_port_block() is
> called...

We haven't seen this in our testing....

> lpfc_ext_debug -- residuals from some test code?

yep - thought I had everything, guess not. I'm rebacking to 
scsi-misc-2.6 and will repost. This will be taken care of.

-- James
