From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: qla2xxx firmware
Date: Fri, 14 Dec 2012 17:53:39 +0100
Message-ID: <50CB5993.4050803@gmail.com>
References: <50C23DF2.4030901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45417 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756588Ab2LNQxq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Dec 2012 11:53:46 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so1868082bkw.19
        for <linux-scsi@vger.kernel.org>; Fri, 14 Dec 2012 08:53:44 -0800 (PST)
In-Reply-To: <50C23DF2.4030901@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Linux-Driver@qlogic.com, linux-scsi@vger.kernel.org

On 12/07/2012 08:05 PM, Xose Vazquez Perez wrote:

> please qlogic guys, send latest fw to upstream linux-firmware.git
> 
> 
> linux-firmware brings old releases:
> File: ql2400_fw.bin
> Version: 5.06.05 MID
> File: ql2500_fw.bin
> Version: 5.06.05 MIDQ
> 
> qlogic-ftp releases:
> ql2400_fw.bin -- 5.08.00 MID
> ql2500_fw.bin -- 5.08.00 MIDQ

btw,
these URIs should be fixed:
qla2xxx/Kconfig:                ftp://ftp.qlogic.com/outgoing/linux/firmware/
qla2xxx/qla_init.c:#define QLA_FW_URL "ftp://ftp.qlogic.com/outgoing/linux/firmware/"

because ftp.qlogic.com is going to disappear, as stated in:
ftp://ftp.qlogic.com/IMPORTANT.THIS.FTP.SITE.TO.BE.SHUTDOWN

---cut---
QLogic Corporation FTP service - Access is monitored
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
                - IMPORTANT NOTICE -
QLogic Corporation will be shutting down this public ftp site by end 
of calendar year 2012.

All users must transition to our replacement service as follows:

QLogic Customers:  Driver downloads are available at
http://driverdownloads.qlogic.com

QLogic Business Partners: Please contact your QLogic counterpart for 
assistance.

QLogic Employees: Please use the new Secure File Transfer service as 
described in the following link. 
http://helpdesk.qlogic.com/AddSolution.do?solID=19288

Please Contact ftp.help@qlogic.com for further assistance
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
---end---
