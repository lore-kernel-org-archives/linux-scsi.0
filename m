From: Joe Scsi <joe.scsi@gmail.com>
Subject: Re: [RFC] target code updates to support scanned targets
Date: Tue, 15 Feb 2005 16:54:58 -0800
Message-ID: <7526e305050215165450200ce2@mail.gmail.com>
References: <7526e305050215152950f5a69e@mail.gmail.com>
	 <1108513997.5539.76.camel@mulgrave>
Reply-To: Joe Scsi <joe.scsi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Received: from wproxy.gmail.com ([64.233.184.199]:47182 "EHLO wproxy.gmail.com")
	by vger.kernel.org with ESMTP id S261400AbVBPAzB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2005 19:55:01 -0500
Received: by wproxy.gmail.com with SMTP id 68so5942wri
        for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2005 16:54:58 -0800 (PST)
In-Reply-To: <1108513997.5539.76.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

> A driver doesn't allocate a target.  In this code, a target device is
> purely a LUN container and is managed by the mid-layer.  The driver
> requests the scan of a target by parent device, channel and id.  This
> request for a scan creates and parents the target object, but reaps it
> again if no actual LUNs are discovered.

OK (and sorry if I'm being dense) but does this mean that a network
SCSI transport should make up an "id" for each target port it connects
to and then call scsi_scan_target()?

Thanks,
  Joe
