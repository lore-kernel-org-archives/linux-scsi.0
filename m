From: David Miller <davem@davemloft.net>
Subject: Re: Major qla2xxx regression on sparc64
Date: Mon, 16 Apr 2007 16:41:11 -0700 (PDT)
Message-ID: <20070416.164111.32625690.davem@davemloft.net>
References: <20070416222517.GD14351@andrew-vasquezs-computer.local>
	<20070416.152910.107940079.davem@davemloft.net>
	<20070416232851.GA15840@dmccrory-d810.qlogic.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56893
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1031027AbXDPXlJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Apr 2007 19:41:09 -0400
In-Reply-To: <20070416232851.GA15840@dmccrory-d810.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, ema@debian.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date: Mon, 16 Apr 2007 16:28:51 -0700

> Sorry, but let's be realistic, this type of warning would have
> *NEVER* been addressed if we kept the status quo

Wrong.  I watch the logs all the time and would have sent you a fix to
use the Sparc firmware info as soon as I saw the kernel log message.

Anyone who has worked with me over the last 15 years will let you know
emphatically that this is true.

AND IN THE MEAN TIME I COULD GET WORK DONE AND MY SYSTEM WOULD BOOT!
