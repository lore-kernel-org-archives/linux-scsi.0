From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: PATCH [5/15] qla2xxx:  SG tablesize update
Date: 16 Mar 2004 16:49:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079473794.1870.18.camel@mulgrave>
References: <B179AE41C1147041AA1121F44614F0B0598FC6@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:55252 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261728AbUCPVuM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Mar 2004 16:50:12 -0500
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598FC6@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Anton Blanchard <anton@samba.org>, Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

So, did you want me to apply the sg_tablesize lowering patch?

I really think performance may suffer from it but, hey, I'm not the one
who has to justify the figures.

James


