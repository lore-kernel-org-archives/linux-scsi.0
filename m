From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Qlogic qla2xxx driver up for testing
Date: 19 May 2003 16:11:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1053378680.1850.24.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:42759 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261790AbTESU61 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2003 16:58:27 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Andrew Morton <akpm@digeo.com>

I've taken the Qlogic 8.00.00.b1 driver and put it up under bitkeeper at

http://linux-scsi.bkbits.net/scsi-qla2xxx-2.5

I've moved the text files into Documentation/scsi, but other than that
made no alterations to the qlogic driver.

It will build for the qla2300, but the builds fail for qla2100 and
qla2200 giving me no way to test it.

The qla2xxx/Makefile is rather convoluted, and makes it look like
building more than one type of driver non-modular may be a problem.

Anyway, for those that can, try it out and see what you think.

James


