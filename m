From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: booting linux from a SAS drive attached to aic94xx
Date: Tue, 12 Sep 2006 09:08:06 -0500
Message-ID: <1158070086.3461.7.camel@mulgrave.il.steeleye.com>
References: <20060911034952.M44911@ms1.dhps.ylc.edu.tw>
	 <4504FAD4.1040700@us.ibm.com>  <20060912122418.M37772@ms1.dhps.ylc.edu.tw>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:22506 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965037AbWILOIX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Sep 2006 10:08:23 -0400
In-Reply-To: <20060912122418.M37772@ms1.dhps.ylc.edu.tw>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: english <english@ms1.dhps.ylc.edu.tw>
Cc: linux-scsi@vger.kernel.org

On Tue, 2006-09-12 at 20:25 +0800, english wrote:
> If anyone knows a simple way to enable to boot linux from a SAS drive attached
> to the adaptec SAS controller, please tell me.

http://marc.theaimsgroup.com/?l=linux-kernel&m=115680315625712

Contains the details for debian mkinitrd.

James


