From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: PATCH [8/11]   qla2xxx: SYSFS queue-depth override
Date: Thu, 09 Dec 2004 08:59:40 -0600
Message-ID: <1102604380.3547.1.camel@mulgrave>
References: <20041209073939.GA22137@plap.san.rr.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:40670 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261525AbULIO75 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2004 09:59:57 -0500
In-Reply-To: <20041209073939.GA22137@plap.san.rr.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2004-12-08 at 23:39 -0800, Andrew Vasquez wrote:
> ChangeSet
>   1.2242 04/12/08 16:48:25 andrew.vasquez@qlogic.com +1 -0
>   Add sysfs queue depth override to qla2xxx.

I'd like not to do this one.  This was really demo code in the 53c700
showing how attribute overriding could be done for individual features.
Since this is now becoming a standard feature, it should have its own
API in the mid-layer ... I'll try to add it.

James


