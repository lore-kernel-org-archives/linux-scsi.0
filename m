From: Brett Russ <russb@emc.com>
Subject: Re: 2.6.14-rc2 hang on Marvell Sata HBA
Date: Thu, 22 Sep 2005 09:52:29 -0400
Message-ID: <4332B71D.5030803@emc.com>
References: <4332B412.40808@exegy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.lss.emc.com ([168.159.2.31]:4074 "EHLO
	mailhub.lss.emc.com") by vger.kernel.org with ESMTP
	id S1030344AbVIVNwl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2005 09:52:41 -0400
In-Reply-To: <4332B412.40808@exegy.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Mr. Berkley Shands" <bshands@exegy.com>
Cc: linux-scsi@vger.kernel.org

Mr. Berkley Shands wrote:
> Note that there are THREE HBAs here, with two logical raid0's each, so 
> there should be 6 drives
> sdb - sdg, not 8.

Hi Berkley,

I've got DMA support done for the 6xxx series but am still debugging a 
SCSI panic in the error handling path.  I'm going to be sending mail 
about it today.  So, soon you'll have something more recent to try.

Thanks,
BR
