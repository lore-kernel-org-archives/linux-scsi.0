From: rct@gherkin.frus.com (Bob Tracy)
Subject: Re: [PATCH] aic7xxx/aicasm build failure w/gcc-3.4.6
Date: Tue, 22 May 2007 10:11:47 -0500 (CDT)
Message-ID: <20070522151147.2BCA5DBA1@gherkin.frus.com>
References: <1179843982.3738.5.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:41033 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756912AbXEVPLs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 May 2007 11:11:48 -0400
In-Reply-To: <1179843982.3738.5.camel@mulgrave.il.steeleye.com>
 "from James Bottomley at May 22, 2007 09:26:22 am"
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

James Bottomley wrote:
> We really don't want gcc making assumptions about prototypes ... even if
> it's getting them right in all likelihood (doubtless unprototyped
> assumed functions will become a warning and then an error in later gcc
> versions ...), so this is a better fix

ACK.  The fix works here.  If you would be so kind, please push it
upstream at your convenience.

gcc-4.X violates the principle of least astonishment over even more
nitnoid matters, but that's another flame for another day.

-- 
-----------------------------------------------------------------------
Bob Tracy               | "Eagles may soar, but weasels don't get
rct@frus.com            |  sucked into jet engines."       --Anon
-----------------------------------------------------------------------
