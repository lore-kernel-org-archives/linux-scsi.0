From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi/initio: section mismatches with HOTPLUG=n
Date: Sat, 25 Nov 2006 09:19:31 -0600
Message-ID: <1164467971.2804.3.camel@mulgrave.il.steeleye.com>
References: <20061119185343.e4dde647.randy.dunlap@oracle.com>
	 <1164408696.2813.19.camel@mulgrave.il.steeleye.com>
	 <1164409859.5257.7.camel@gullible>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:14014 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S966629AbWKYPTn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 25 Nov 2006 10:19:43 -0500
In-Reply-To: <1164409859.5257.7.camel@gullible>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <ben.collins@ubuntu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>

On Fri, 2006-11-24 at 18:10 -0500, Ben Collins wrote:
> The patch went in with about half a dozen others for similar changes, so
> it was a group set.
> 
> Sorry about the mismatches. I've only been building with HOTPLUG=y.
> 
> I can do a patch if you want, just let me know.

Well, I was sort of hoping you weren't just randomly introducing
__devinitdata but had all the necessary support patches for converting
the driver to hotplug.  However, if that's not the case, the safest
thing to do is remove the section annotation ... I don't think anyone
cares enough about this driver to convert it fully and test it.

James


