From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: 2.5.70 Adaptec error messages
Date: Thu, 05 Jun 2003 10:01:24 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1571790000.1054828884@aslan.btc.adaptec.com>
References: <5.1.0.14.2.20030605162325.055137f0@pop.t-online.de>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([208.236.45.100]:39582 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S264722AbTFEPrP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jun 2003 11:47:15 -0400
In-Reply-To: <5.1.0.14.2.20030605162325.055137f0@pop.t-online.de>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Margit Schubert-While <margitsw@t-online.de>, linux-scsi@vger.kernel.org

> With 2.5.70(-bk) and also Justin's 20030603, I am getting the below at boot.
> After that, everything works fine.
> Adapter is 39160.

Someone is fetching the device serial number without setting the
cmd underflow to 0.  The response length is variable, so telling
the adapter to fail the command when the returned result is less
than the allocated buffer size is counter productive.

--
Justin

