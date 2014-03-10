From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 3/5] Add EVPD page 0x83 to sysfs
Date: Mon, 10 Mar 2014 18:24:59 +0000
Message-ID: <1394475897.2565.46.camel@dabdike.int.hansenpartnership.com>
References: <1394461725-76203-1-git-send-email-hare@suse.de>
	 <1394461725-76203-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:55658 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbaCJSZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Mar 2014 14:25:40 -0400
In-Reply-To: <1394461725-76203-4-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <E614DC81098B924E918A96CF77B4517D@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "bvanassche@acm.org" <bvanassche@acm.org>, "hch@infradead.org" <hch@infradead.org>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "jlinton@tributary.com" <jlinton@tributary.com>, "kai.makisara@kolumbus.fi" <kai.makisara@kolumbus.fi>, "kay@vrfy.org" <kay@vrfy.org>

On Mon, 2014-03-10 at 15:28 +0100, Hannes Reinecke wrote:
> EVPD page 0x83 is used to uniquely identify the device.
> So instead of having each and every program issue a separate
> SG_IO call to retrieve this information it does make far more
> sense to display it in sysfs.

Christoph's suggestion of binary sysfs attributes for this rather than
the text ones you have is better ... because your current ones are going
to truncate when they run off the one page of data sysfs text attributes
get (i.e. about 2k of vpd).

James

