From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: SCSITAP, Virtual SCSI HBA and user space SCSI initiators
Date: Thu, 12 Oct 2006 18:02:42 -0500
Message-ID: <1160694162.3432.48.camel@mulgrave.il.steeleye.com>
References: <1160675319.3432.34.camel@mulgrave.il.steeleye.com>
	 <c3b66b980e163824b0079e07578624da@aboo.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:14735 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751294AbWJLXCt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Oct 2006 19:02:49 -0400
In-Reply-To: <c3b66b980e163824b0079e07578624da@aboo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aboo <aboo@aboo.org>
Cc: linux-scsi@vger.kernel.org

On Fri, 2006-10-13 at 08:13 +1000, aboo wrote:
> Is'nt this a target implimentation, rather than a initiator? That page
> does not give me more details. I have sent an email to the author of
> the project to get more details. Hopefully, they will reply :)

It's designed for use by a target driver ... but there's no reason why a
virtual initator couldn't also make use of the infrastructure; it's
basically just a way to pass commands up and down plus the SG elements.

James


