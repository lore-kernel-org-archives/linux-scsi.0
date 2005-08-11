From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Thu, 11 Aug 2005 08:59:27 -0500
Message-ID: <1123768768.5062.1.camel@mulgrave>
References: <OFBC81092C.89B6F4D5-ONC125705A.00365E9F-C125705A.0037CB40@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:27809 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030311AbVHKN7b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Aug 2005 09:59:31 -0400
In-Reply-To: <OFBC81092C.89B6F4D5-ONC125705A.00365E9F-C125705A.0037CB40@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harald Seipp <SEIPP@de.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-08-11 at 12:09 +0200, Harald Seipp wrote:
> I assume this is a bug? How can I prevent that behavior? Can I easily query
> if a device on "h b t l" is mounted to work-around?

No, it's expected behaviour.  The mount keeps a reference to the old
device node so it can't be reused.

James


