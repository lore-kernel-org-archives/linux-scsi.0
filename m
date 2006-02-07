From: Tore Anderson <tore@linpro.no>
Subject: Re: In-kernel QLE2462 driver LU enumeration bug?
Date: Tue, 07 Feb 2006 09:16:50 +0100
Message-ID: <1139300210.20401.7.camel@echo.e.linpro.no>
References: <1138279741.1318.76.camel@echo.e.linpro.no>
	 <20060206231150.GG9044@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from head.linpro.no ([80.232.36.1]:62175 "EHLO head.linpro.no")
	by vger.kernel.org with ESMTP id S1750917AbWBGIRA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2006 03:17:00 -0500
In-Reply-To: <20060206231150.GG9044@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org

* Andrew Vasquez

> Please try the attached patch -- not sure how this was missed as it's
> been in my patch-queue for some time.

  Thanks, Andrew!  Your patch fixes the bug for me.  I hope it's not too
 late for 2.6.16 inclusion.

Kind regards
-- 
Tore Anderson

