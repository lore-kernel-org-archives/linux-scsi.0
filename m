From: Jes Sorensen <jes@sgi.com>
Subject: device settings past a bus reset
Date: 17 Oct 2006 10:45:34 -0400
Message-ID: <yq0k62z9f1t.fsf@jaguar.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:22936 "EHLO jaguar.mkp.net")
	by vger.kernel.org with ESMTP id S1751099AbWJQOpf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Oct 2006 10:45:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@steeleye.com

Hi,

I have a bug report about the qla1280 driver dropping the per device
negotiated settings past a bus reset. I could in principle try and
keep a list of configured devices in the driver, but it seems to me
that it would be reasonable that the SCSI layer should call
->slave_configure() again for each configured device after a bus
reset?

Anyone else seeing this in other drivers and have any oppinion on it?

Cheers,
Jes
