From: TomK <tk@mdevsys.com>
Subject: Re: CONFIG_TCM_QLA2... no longer in Kernel 4.8.4 as an option.
Date: Sun, 23 Oct 2016 11:47:57 -0400
Message-ID: <fa97b53d-36c3-f94c-e3df-113d9b035647@mdevsys.com>
References: <68ab9181-1db9-1111-98d4-ab67387180cb@mdevsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:60559 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755502AbcJWPsD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 23 Oct 2016 11:48:03 -0400
In-Reply-To: <68ab9181-1db9-1111-98d4-ab67387180cb@mdevsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "tomkcpr@microdevsys.com" <tomkcpr@microdevsys.com>

Resending because the Triple X get's filtered in subjects 
CONFIG_TCM_QLA2...  (Removed it from the body as well)

Basically these two options are no longer available in the latest stable 
kernel.  Wondering if this option is being deprecated.

          -> QLogic QLA2XXX Fibre Channel Support (SCSI_QLA_FC [=m])
           -> [m] TCM_QLA2XXX fabric module for Qlogic 2xxx series 
target mode HBAs

Cheers,
Tom K.
-------------------------------------------------------------------------------------

Living on earth is expensive, but it includes a free trip around the sun.


On 10/23/2016 1:05 AM, TomK wrote:
> Hello,
>
> The latest 4.8.4 kernel is missing the following kernel option
> CONFIG_TCM_QLA2... .  Are there more recent instructions?  Or is this
> option on it's way out of the kernel?
>
> http://linux-iscsi.org/wiki/Downloads
>
> QLogic Fibre Channel
> Optionally, enable the QLogic Fibre Channel target module (qla2xxx.ko),
> including its SCSI LLD:
>         Device Drivers --->
>                  SCSI device support  --->
>                          [*] SCSI low-level drivers  --->
>
>                  --- SCSI low-level drivers
>                    <M>   QLogic QLA2... Fibre Channel Support
>                    <M>   TCM_QLA2... fabric module for Qlogic 2xxx
> series target mode HBAs
>
