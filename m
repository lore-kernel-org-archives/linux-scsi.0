From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: RE: [PATCH 1/1] cciss: fix error reporting for SG_IO
Date: Thu, 16 Aug 2007 14:53:55 -0000
Message-ID: <558F4D473FD7FE419B019232BF2D37B401168058@G3W0634.americas.hpqcorp.net>
References: <20070814195338.GA10828@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas03.cce.hp.com ([161.114.21.106]:52983 "EHLO
	ccerelbas03.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbXHPPXe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Aug 2007 11:23:34 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, james.bottomley@steeleye.com, hch@infradead.org


Any feedback on my patch?

Anybody know what the msg_byte in include/scsi/scsi.h
is for?

scsi.h says:
 *      msg_byte    = return status from host adapter itself.

So, it's ok to use the msg_byte for device specific error codes?

-- steve
