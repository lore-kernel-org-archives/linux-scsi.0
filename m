From: Fabien Salvi <fabien@cri74.org>
Subject: Re: Performance
Date: Fri, 02 Aug 2002 11:16:34 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D4A4DF2.539B1168@cri74.org>
References: <20020802075037.66373.qmail@web14001.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Mukul Kotwani <mkotwani@yahoo.com>
Cc: linux-scsi@vger.kernel.org

Mukul Kotwani wrote:
> 
> Hello!
> Does anyone have any performace numbers of a Qlogic
> HBA? No of IOps/sec Max MBs /sec?

I think it depends more on your controllers than on the HBA...

In our tests with a CMD 7240 controller, we have approx. 40 MB/s for
large file transfers.
I don't remember IO/s values...

-------------
Fabien SALVI      Centre de Ressources Informatiques
                  Archamps, France -- http://www.cri74.org
                  PingOO GNU/linux distribution : http://www.pingoo.org
