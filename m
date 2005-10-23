From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH RFC] more struct scsi_lun
Date: Sun, 23 Oct 2005 15:14:49 +0200
Message-ID: <435B8CC9.5000600@s5r6.in-berlin.de>
References: <20051023043301.GA22615@havoc.gtf.org> <20051023044953.GA23354@havoc.gtf.org> <435B5C15.5070106@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:64184 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750707AbVJWNPT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 09:15:19 -0400
In-Reply-To: <435B5C15.5070106@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org

I wrote:
>        for (i = 0; i < 8; ++i)
>                sprintf(s+2*i, %02x, lun[i]);
                  sprintf(s+2*i, "%02x", lun.scsi_lun[i]);
#-)
-- 
Stefan Richter
-=====-=-=-= =-=- =-===
http://arcgraph.de/sr/
