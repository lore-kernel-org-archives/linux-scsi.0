From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] aic94xx: convert to request_firmware interface
Date: Mon, 28 Aug 2006 16:43:50 -0400
Message-ID: <44F35586.1040505@torque.net>
References: <1156733286.3460.26.camel@mulgrave.il.steeleye.com>	 <1156736843.3460.31.camel@mulgrave.il.steeleye.com>	 <44F2E6F2.2090706@torque.net> <1156773918.3465.7.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:47068 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751508AbWH1Un4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Aug 2006 16:43:56 -0400
In-Reply-To: <1156773918.3465.7.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Mon, 2006-08-28 at 08:52 -0400, Douglas Gilbert wrote:
>> I presume that is a version of the infamous "razor"
>> code. How do I know which version it is (before trying
>> it)?
> 
> Well ... same way you do any binary blob with version text in it ... use
> strings.

James,
What I'm angling at is a firmware file name like:
   aic94xx-seq_10c6.req

and the driver attempts to read:
   aic94xx-seq*.req

If there a multiple matches then it takes the one
with the most recent date (reporting this in syslog).


For the benefit of others: in my experience the
stability of my adaptec 48300 SAS HBA is somewhat
related to the firmware level it is running (both
the card BIOS and when the linux driver has
taken over).

Doug Gilbert

