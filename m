From: Mogens Valentin <monz@danbbs.dk>
Subject: Re: SATA status report updated
Date: Fri, 12 Aug 2005 21:17:39 +0200
Message-ID: <42FCF5D3.1080409__19709.2343507849$1123874395$gmane$org@danbbs.dk>
References: <42FC2EF8.7030404@pobox.com>
Reply-To: monz@danbbs.dk
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <42FC2EF8.7030404@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Linux IDE Mailing List <linux-ide@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> 
> Things in SATA-land have been moving along recently, so I updated the 
> software status report:
> 
>     http://linux.yyz.us/sata/software-status.html

 >> Queueing support, NCQ:
 >> #3 will be supported by libata, for all hardware and devices that
 >> support NCQ.

I guess this means libata support for HW-based NCQ.
It also could mean software/driver implemented NCQ, which could work on 
chipsets not supporting HW-NCQ in unison with a disk having NCQ?

> Although I have not updated it in several weeks, folks may wish to refer 
> to the hardware status report as well:
> 
>     http://linux.yyz.us/sata/sata-status.html

How well does libata work with the newest ULi chipsets?
If not well, is there a possible timeframe?


(not on kernel list; if anyone there comments on ULi, pls. cc private)

-- 
Kind regards,
Mogens Valentin

