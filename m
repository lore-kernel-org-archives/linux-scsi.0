From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Dell 660F needs BLIST_LARGELUN
Date: 30 Sep 2004 14:48:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096570128.2152.66.camel@mulgrave>
References: <fa7105a5040930112612ae0bf4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:8929 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S269386AbUI3StC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Sep 2004 14:49:02 -0400
In-Reply-To: <fa7105a5040930112612ae0bf4@mail.gmail.com>
List-Id: linux-scsi@vger.kernel.org
To: misterbawb@gmail.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-09-30 at 14:26, misterbawb@gmail.com wrote:
> I have a 660F array here with 14 LUNs, and 2.6.8.1 fails to detect any
> past the first 8.  Attached is a patch to fix that.

Well, since you have one of these things, could you see how it responds
to report luns?  If it says it's ansi scsi version in 2, you'll have to
try it with the BLIST_REPORTLUNS2 flag (we only automatically try report
luns on SCSI-3 and higher devices).

James


