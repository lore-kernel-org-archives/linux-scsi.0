From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] use one-element sg list in scsi_send_eh_cmnd
Date: Mon, 06 Nov 2006 09:51:56 +0100
Message-ID: <454EF7AC.2040804@s5r6.in-berlin.de>
References: <20061104190421.GA23477@lst.de> <200611031813.21938.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:6837 "EHLO
	hp3.statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S1423623AbWKFIv6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Nov 2006 03:51:58 -0500
In-Reply-To: <200611031813.21938.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

Rolf Eike Beer wrote on 2006-11-03:
> Christoph Hellwig wrote:
>> + * @cmnd_size:  size if bytes of @cmnd
>                          ^
> "in"?

"size of @cmnd, in bytes"?
-- 
Stefan Richter
-=====-=-==- =-== --==-
http://arcgraph.de/sr/
