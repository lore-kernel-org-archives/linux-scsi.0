From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: scsi_scan_target and SCSI_2
Date: 27 Nov 2003 09:57:20 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069948641.1913.41.camel@mulgrave>
References: <200311252037.34015.krmurthy@cisco.com>
	<200311271849.15241.krmurthy@cisco.com> <1069947459.1837.28.camel@mulgrave>
	 <200311272115.28094.krmurthy@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:54532 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264546AbTK0P5a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Nov 2003 10:57:30 -0500
In-Reply-To: <200311272115.28094.krmurthy@cisco.com>
List-Id: linux-scsi@vger.kernel.org
To: Krishna Murthy <krmurthy@cisco.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

On Thu, 2003-11-27 at 09:45, Krishna Murthy wrote:
> 	What I intended to say was in case we get 3 as the peripheral qualifier
> in response to inquiry on lun 0, shouldn't we use the scsi level as returned 
> in inquiry response instead of using a a default scsi level of SCSI_2.

It's open to debate whether a device reporting PQ 3 is required to fill
in all the rest of the inquiry data correctly.  The code takes the most
conservative view.

James


