From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Help - interface between Linux SCSI mid-level driver and
	lower-level driver
Date: 26 Mar 2004 09:35:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080311752.1756.1.camel@mulgrave>
References: <519672568F040C41B6FAC21ADF51B18FF7C8@mailnode1.commstor.crossroads.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:8620 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263361AbUCZOf6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Mar 2004 09:35:58 -0500
In-Reply-To: <519672568F040C41B6FAC21ADF51B18FF7C8@mailnode1.commstor.crossroads.com>
List-Id: linux-scsi@vger.kernel.org
To: Lee Xing <lxing@Crossroads.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-03-24 at 15:12, Lee Xing wrote:
> My question is what are the interface functions in SCSI mid-level driver we can invoke to register the detected FC/SCSI devices as Linux sg/sd devices.  Sample code and documents would be a great help.

Documentation/scsi/scsi_mid_low_api.txt

Is a good starting point.

James


