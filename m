From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: 2.5.70 Adaptec error messages
Date: Thu, 05 Jun 2003 10:40:58 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1597600000.1054831258@aslan.btc.adaptec.com>
References: <5.1.0.14.2.20030605162325.055137f0@pop.t-online.de> <5.1.0.14.2.20030605162325.055137f0@pop.t-online.de> <5.1.0.14.2.20030605181315.00aed370@pop.t-online.de>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:48548 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S264757AbTFEQ0n
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jun 2003 12:26:43 -0400
In-Reply-To: <5.1.0.14.2.20030605181315.00aed370@pop.t-online.de>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Margit Schubert-While <margitsw@t-online.de>
Cc: linux-scsi@vger.kernel.org

> At 10:01 05.06.2003 -0600, Justin wrote:
>> Someone is fetching the device serial number without setting the
>> cmd underflow to 0.  The response length is variable, so telling
>> the adapter to fail the command when the returned result is less
>> than the allocated buffer size is counter productive.
> 
> Hmm, doesn't happen with 2.4.21rc + Justin's driver.
> Which, for me, would imply the kernel - right ?
> If so, I will post at linux-kernel.
> If not, educate me :-)
> 
> Margit

It is not the driver's fault unless the semantics of the underflow
field in the SCSI command structure have changed.

--
Justin

