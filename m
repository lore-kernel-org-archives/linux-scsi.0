From: Mathieu Chouquet-Stringer <mchouque@free.fr>
Subject: Re: class_device_add error in SCSI with 2.6.17-rc2-g52824b6b
Date: Thu, 20 Apr 2006 00:17:56 +0200
Message-ID: <20060419221756.GA12149@localhost>
References: <20060419213129.GA9148@localhost> <20060419215803.6DE5BDBA1@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp13.wanadoo.fr ([193.252.22.54]:28891 "EHLO
	smtp13.wanadoo.fr") by vger.kernel.org with ESMTP id S1751085AbWDSWS6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 18:18:58 -0400
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf1309.wanadoo.fr (SMTP Server) with ESMTP id A97457000093
	for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2006 00:18:57 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20060419215803.6DE5BDBA1@gherkin.frus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Wed, Apr 19, 2006 at 04:58:03PM -0500, Bob Tracy wrote:
> Similar error previously reported by me for 2.6.17-rc1, except sda got
> added fine: error occurred when attempting to add/register sdb. 

Actually you're right. I'm rereading the logs and the first device on a
scsi bus is always registered correctly. The sh*t hits the fan when you
have more than one sd device per bus. (I've got 2 devices on one, and 3
on the other and only the first one on each got registered correctly).

> Thankfully, you were able to append a trace...

I used the serial console.

> I'll be trying the just-released 2.6.17-rc2 this evening.  Report to
> follow, and if there's a problem, I'll attempt to provide the trace
> (will have to be transcribed by hand, as system won't come up far
> enough for syslog to capture anything).

If syslog doesn't come up and depending on the state of your system you
could redirect dmesg output to a file.
-- 
Mathieu Chouquet-Stringer                           mchouque@free.fr

