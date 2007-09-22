From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 6/9] mpt fusion: error recovery improvements, and
	synchronizing internal commands
Date: Sat, 22 Sep 2007 11:01:51 -0500
Message-ID: <1190476911.3347.19.camel@localhost.localdomain>
References: <20070918015952.GA22742@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:48904 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751561AbXIVQBx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Sep 2007 12:01:53 -0400
In-Reply-To: <20070918015952.GA22742@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2007-09-17 at 19:59 -0600, Eric Moore wrote:
> 3) mdr@sgi.com - fix's provided from SGI after testing with single threaded internal commands

What fixes?

The object of a change log is to preserve the history of a particular
change (as per the Developer Certificate of Origin).  This means if you
get a patch from someone, you should also collect their signoff with it,
then you pass it on to me complete with your signoff added (and a note
if you had to modify it to fit it into the patch series or otherwise
alter it).

James


