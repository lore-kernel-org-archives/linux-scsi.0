From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 00/12] scsi/NCR5380: fix debugging macros and #include
 structure
Date: Mon, 17 Mar 2014 20:19:16 -0700
Message-ID: <1395112756.20860.1.camel@joe-AO722>
References: <20140318002822.372705594@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay0146.hostedemail.com ([216.40.44.146]:33208 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751706AbaCRDTU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2014 23:19:20 -0400
In-Reply-To: <20140318002822.372705594@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>, Russell King <linux@arm.linux.org.uk>, Michael Schmitz <schmitz@debian.org>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-m68k@vger.kernel.org

On Tue, 2014-03-18 at 11:28 +1100, Finn Thain wrote:
> This patch series addresses several issues with NCR5380 drivers:
[]
> 3. Broken debugging code.

My preference would be to change dprintk to scsi_dbg

Seems sensible otherwise.

