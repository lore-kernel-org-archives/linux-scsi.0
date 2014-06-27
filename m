From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: help decoding aacraid errors (3.10.40 kernel)
Date: Fri, 27 Jun 2014 11:41:32 +0100
Message-ID: <20140627104131.GD10042@localhost.localdomain>
References: <201406271055.08750.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaF0Klk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2014 06:41:40 -0400
Content-Disposition: inline
In-Reply-To: <201406271055.08750.a.miskiewicz@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Jun 27, 2014 at 10:55:08AM +0200, Arkadiusz Miskiewicz wrote:
> [3757350.671860] Result: hostbyte=0x00 driverbyte=0x08
> [3757350.671862] sd 0:0:2:0: [sdc]  
> [3757350.671863] Sense Key : 0x4 [current] 

http://www.t10.org/lists/2sensekey.htm

0x4 is "hardware error".

> [3757350.671866] sd 0:0:2:0: [sdc]  
> [3757350.671868] ASC=0x44 ASCQ=0x0

http://www.t10.org/lists/asc-num.htm

0x44/0x00 is "internal target failure".

Regards,
Bryn.

