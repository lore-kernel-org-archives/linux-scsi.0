From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [BK PATCH] SCSI updates for 2.6.9
Date: 19 Oct 2004 08:54:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1098194090.1714.3.camel@mulgrave>
References: <1098137016.2011.339.camel@mulgrave>
	<200410182341.13648.dtor_core@ameritech.net>
	<200410190012.28071.dtor_core@ameritech.net>
	<Pine.LNX.4.58.0410190009260.2287@ppc970.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:52156 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269411AbUJSNzD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Oct 2004 09:55:03 -0400
In-Reply-To: <Pine.LNX.4.58.0410190009260.2287@ppc970.osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: Ben Collins <bcollins@debian.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor_core@ameritech.net>, Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, willy@debian.org, Linux1394-Devel <linux1394-devel@lists.sourceforge.net>

On Tue, 2004-10-19 at 02:13, Linus Torvalds wrote:
>  does this look ok to you?
> 
> Arguably the SCSI layer should also have proper prefixes for its constants
> - and in fact they do kind of exist as the GPCMD_xxx constants.  Oh, well.
> Regardless, the sbp2 constants do look like they want prefixing..

We're slowly standardising at least some of our namespace problems.

The condition codes are all migrating to SAM_STAT_ prefix, so
CHECK_CONDITION becomes SAM_STAT_CHECK_CONDITION (and gets shifted in
the process).

We still have a nasty namespace pollution problem on the SCSI commands
though and cleaning this up is problematic since they permeate not just
SCSI but large areas of other drivers as well.

James


