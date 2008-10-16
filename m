From: CaT <cat@zip.com.au>
Subject: Re: [PATCH 4/5] scsi: megaraid_sas - preallocate memory for ioctl processing
Date: Fri, 17 Oct 2008 08:51:12 +1100
Message-ID: <20081016215112.GX19077@zip.com.au>
References: <20081016001721.GW19077@zip.com.au> <4B6A08C587958942AA3002690DD4F8C32D24DF36@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from CPE-124-189-54-71.nsw.bigpond.net.au ([124.189.54.71]:49765
	"EHLO bunyip.billabong.weebeastie.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754708AbYJPWg7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Oct 2008 18:36:59 -0400
Content-Disposition: inline
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C32D24DF36@cosmail02.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@linux-foundation.org>, "Patro, Sumant" <Sumant.Patro@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Kolli, Neela" <Neela.Kolli@lsi.com>

On Thu, Oct 16, 2008 at 07:54:07AM -0600, Yang, Bo wrote:
> What MegaCli cmds did you using (DCMD or DCDB?).

MegaCli -LdPdInfo -a0 -NoLog

Forgot to mention that this is the 64bit version of the command.

-- 
  "Police noticed some rustling sounds from Linn's bottom area
  and on closer inspection a roll of cash was found protruding
  from Linn's anus, the full amount of cash taken in the robbery."
    - http://www.smh.com.au/news/world/robber-hides-loot-up-his-booty/2008/05/09/1210131248617.html
