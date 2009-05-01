From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] libfc,fcoe,fnic: Separate rport and lport max retry
	counts
Date: Fri, 01 May 2009 17:08:41 +0000
Message-ID: <1241197721.3302.35.camel@mulgrave.int.hansenpartnership.com>
References: <20090501165111.16733.31537.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37467 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760765AbZEARIm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2009 13:08:42 -0400
In-Reply-To: <20090501165111.16733.31537.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Abhijeet Joglekar <abjoglek@cisco.com>
Cc: linux-scsi@vger.kernel.org, robert.w.love@intel.com

On Fri, 2009-05-01 at 10:01 -0700, Abhijeet Joglekar wrote:
> This patch is a minor update to the libfc/fcoe/fnic drivers. It adds a
> separate knob to libFC to allow the lower-level driver (fnic or fcoe) to
> configure the number of retries for lport and rport separately.
> 
> Its not a bug fix, so it didnt get submitted along with Robert's previous
> set of libFC fixes for -rc4. Since its needed for fnic, maybe, it can go
> along with the fnic changes in scsi-misc. Will that work?

Sure, but I thought you wanted fnic in -rc-fixes for 2.6.30?

James


