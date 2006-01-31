From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [GIT PATCH] SCSI bug fixes for 2.6.16-rc1
Date: Tue, 31 Jan 2006 17:09:50 -0600
Message-ID: <1138748990.3307.33.camel@mulgrave>
References: <1138741016.3307.20.camel@mulgrave>
	 <43DFD316.3080100@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:38098 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751055AbWAaXKA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2006 18:10:00 -0500
In-Reply-To: <43DFD316.3080100@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2006-01-31 at 15:13 -0600, Brian King wrote:
> Any reason the other sg patch I submitted didn't get pushed?

Er ... I didn't notice it go by and no-one told me?

> http://marc.theaimsgroup.com/?l=linux-scsi&m=113753907627483&w=2
> 
> I was hoping to see this one go into the rc fixes, since without
> it ipr's RAID configuration tools do not work.

In theory, it only affects the sg path, the path via the ULD device node
should already be fixed, so any management tool could use the sd (or st
or sr) node instead ... you probably want to do that anyway to avoid
mapping issues between the sg and sd nodes.

James


