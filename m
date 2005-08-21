From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] minimal SAS transport class
Date: Sun, 21 Aug 2005 11:23:53 -0700 (PDT)
Message-ID: <20050821182354.27330.qmail@web51606.mail.yahoo.com>
References: <20050821165250.GA18942@lst.de>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeus1.kernel.org ([204.152.191.4]:30668 "EHLO zeus1.kernel.org")
	by vger.kernel.org with ESMTP id S1751138AbVHUVe0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 21 Aug 2005 17:34:26 -0400
Received: from web51606.mail.yahoo.com (web51606.mail.yahoo.com [206.190.38.211])
	by zeus1.kernel.org (8.13.1/8.13.1) with SMTP id j7LIPBUo028377
	for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2005 11:25:11 -0700
In-Reply-To: <20050821165250.GA18942@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: luben_tuikov@adaptec.com, hch@lst.de, jejb@steeleye.com, ltuikov@yahoo.com, Eric.Moore@lsil.com, andrew.patterson@hp.com, linux-scsi@vger.kernel.org

--- Christoph Hellwig <hch@lst.de> wrote:
> > For SAS, looking at Christoph's code - 
> > The target id comes from the LLDD.
> 
> This is just a brindup helper because the Fusion hardware does a SAS
> remote port to target ID mapping in firmware, in fact the firmware
> interface only addresses them using this assigned ID, which is a big
> shortcoming in the Fusion interface.  Once the more basic things are

:-)

> dealt with that will go away, similarly to how Fusion won't be able
> to use their firmware mapping for FC once they fully support the FC
> transport class.

You should not deny the possibility of vendors providing "HCIL" or
any other (kind of) label for the LU.

However it is possible to move into the 21st century _and_ provide
HCIL or any other (kind of) label to anyone who's interested.

Vendors would want to name the LU something, so that it is identifiable
to end users.  Vendors may want to provide one or many labels.

     Luben



