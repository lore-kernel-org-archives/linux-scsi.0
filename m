From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: =?UTF-8?Q?=E7=AD=94=E5=A4=8D=3A?= libsas error-handling
	completion issue.
Date: Sun, 15 Mar 2009 12:13:30 -0500
Message-ID: <1237137211.4376.17.camel@localhost.localdomain>
References: <FE3F06125A99254E8D92161AA4569C6F0687BCA0@sc-exch02.marvell.com>
	 <1237051145.3907.43.camel@localhost.localdomain>
	 <FE3F06125A99254E8D92161AA4569C6F0687BD47@sc-exch02.marvell.com>
	 <1237126471.4376.10.camel@localhost.localdomain>
	 <FE3F06125A99254E8D92161AA4569C6F029F0621@sc-exch02.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37658 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748AbZCORNg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Mar 2009 13:13:36 -0400
In-Reply-To: <FE3F06125A99254E8D92161AA4569C6F029F0621@sc-exch02.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ying Chu <jasonchu@marvell.com>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, Tejun Heo <tj@kernel.org>

On Sun, 2009-03-15 at 08:59 -0700, Ying Chu wrote:
> Thanks, I'll figure out why my system hangs after 5 times retry.

Just as a point of mailing list etiquette, this email had a text/html
part ... vger is very intolerant of these, which is why it needs to be
text/plain only ... there's probably an outlook setting (I think it's
recipient doesn't want enriched mail) to fix this.

Failing after five retries sounds significant:  5 is SD_MAX_RETRIES, so
it sounds like something failed after the allowed number of retries was
exhausted.

James


