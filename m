From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: About ARECA RAID driver for Linux i386/x86-64
Date: Thu, 03 Feb 2005 22:10:28 -0600
Message-ID: <1107490229.5502.52.camel@mulgrave>
References: <003f01c509a9$87913290$9300a8c0@erich2003>
	 <20050202205141.0c28faf4.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:8384 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S270810AbVBDELD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Feb 2005 23:11:03 -0500
In-Reply-To: <20050202205141.0c28faf4.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: erich <erich@areca.com.tw>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-02-02 at 20:51 -0800, Andrew Morton wrote:
> Well that's a decision which the scsi maintainers will need to make.  Lots
> of current drivers use LINUX_VERSION_CODE, even though we'd prefer they not
> do so.  I don't know what the scsi policy is for new submissions.

Hey ... I have to have a policy now?

The policy generally is that new submissions need to use the latest
versions of the API.  If the driver needs to work on 2.4, it should use
the 2.4 compat layer for 2.6 drivers (and if there's a problem or
something missing, we can update 2.4).

James


