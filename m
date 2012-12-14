From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: qla2xxx firmware
Date: Fri, 14 Dec 2012 13:06:16 -0500
Message-ID: <alpine.WNT.2.00.1212141303260.7460@N5102REMCQXM4BS.qlogic.org>
References: <50C23DF2.4030901@gmail.com> <50CB5993.4050803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:37853 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756545Ab2LNSGm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Dec 2012 13:06:42 -0500
In-Reply-To: <50CB5993.4050803@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Dept-Eng Linux Driver <Linux-Driver@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



On Fri, 14 Dec 2012, Xose Vazquez Perez wrote:

> On 12/07/2012 08:05 PM, Xose Vazquez Perez wrote:
>
>> please qlogic guys, send latest fw to upstream linux-firmware.git
>>
>>
>> linux-firmware brings old releases:
>> File: ql2400_fw.bin
>> Version: 5.06.05 MID
>> File: ql2500_fw.bin
>> Version: 5.06.05 MIDQ
>>
>> qlogic-ftp releases:
>> ql2400_fw.bin -- 5.08.00 MID
>> ql2500_fw.bin -- 5.08.00 MIDQ
>
> btw,
> these URIs should be fixed:
> qla2xxx/Kconfig:                ftp://ftp.qlogic.com/outgoing/linux/firmware/
> qla2xxx/qla_init.c:#define QLA_FW_URL "ftp://ftp.qlogic.com/outgoing/linux/firmware/"
>
> because ftp.qlogic.com is going to disappear, as stated in:
> ftp://ftp.qlogic.com/IMPORTANT.THIS.FTP.SITE.TO.BE.SHUTDOWN
>
> ---cut---
> QLogic Corporation FTP service - Access is monitored
> =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
>                - IMPORTANT NOTICE -
> QLogic Corporation will be shutting down this public ftp site by end
> of calendar year 2012.
>
> All users must transition to our replacement service as follows:
>
> QLogic Customers:  Driver downloads are available at
> http://driverdownloads.qlogic.com
>
> QLogic Business Partners: Please contact your QLogic counterpart for
> assistance.
>
> QLogic Employees: Please use the new Secure File Transfer service as
> described in the following link.
> http://helpdesk.qlogic.com/AddSolution.do?solID=19288
>
> Please Contact ftp.help@qlogic.com for further assistance
> =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
> ---end---
>
>

Hi Xose,

Thanks for the heads up.  We have a patch pending (but no submitted yet)
that will fix the FTP URIs.  We will also be send a pull request to
update the firmware soon.

Thanks,
Chad

________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

