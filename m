From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Using ncr53c8xx.c for a 53c770 chip
Date: 13 Jan 2004 11:45:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074012337.2173.131.camel@mulgrave>
References: <20031122113834.GA8098@lst.de>
	<20031123175041.A1461@sygehus.dk> <1069606797.2066.2.camel@mulgrave>
	<20040113145553.A1738@sygehus.dk>  <20040113151503.B1738@sygehus.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:20401 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264411AbUAMQpl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2004 11:45:41 -0500
In-Reply-To: <20040113151503.B1738@sygehus.dk>
List-Id: linux-scsi@vger.kernel.org
To: Rask Ingemann Lambertsen <rask@sygehus.dk>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-01-13 at 09:15, Rask Ingemann Lambertsen wrote:
> I just got hold of the 53c770 programming guide, and it helps a lot with
> this part, but comments are still welcome, of course.

OK, I forgot to say that because you have a non-standard 50MHz clock,
you'll need to set FE_VARCLK to make the driver compute the clock speed.

James


