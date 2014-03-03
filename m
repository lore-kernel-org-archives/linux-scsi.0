From: Istvan Hubay Cebrian <istvan.cebrian@gmail.com>
Subject: Dell Shared PERC8 RAID Controller
Date: Mon, 3 Mar 2014 14:53:36 +0000
Message-ID: <CABA7EgDjuvvwYDxzYgO1qQLjTAXbjiqccnF0CxCsJAyz+xDZ7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:37703 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050AbaCCOx5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2014 09:53:57 -0500
Received: by mail-vc0-f176.google.com with SMTP id la4so3637757vcb.21
        for <linux-scsi@vger.kernel.org>; Mon, 03 Mar 2014 06:53:56 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

Am sending this email here as I think it is possibly the most
appropriate place. If not, please disregard/ignore and my apologizes.

Recently I have bought a new Dell PowerEdge VRTX Enclosure
(http://www.dell.com/us/business/p/poweredge-vrtx/pd) that houses Dell
PowerEdge M520 Blade server
(http://www.dell.com/us/business/p/poweredge-m520/pd).

This solution (http://bladesmadesimple.com/2013/06/a-detailed-look-at-dell-poweredge-vrtx/),
released specifically for the SMB market currently only works with
Windows Server 2008+ and VMware ESXi.

This due to a controller called the Shared PERC8 RAID Controller
(http://www.dell.com/support/drivers/us/en/19/driverdetails?driverid=7HPN0)
which apparently is not supported in Linux.

I have been trying to get feedback from Dell for nearly 1 year now but
to no avail. Dell say's it is not supported and that it is the
community that needs to provide the drivers first. When I asked if
they where providing support to the community I never received a
response.

What I don't understand is how VMware ESXi which I believe uses the
Linux Kernel is already supported and it can work with said
controller. Possibly because it does not use MegaRAID drivers? Not
sure.

This email is either to discuss this matter further or aimed at
requesting support for the Dell Shared PERC8 RAID Controller in order
to allow such platforms as the VRTX and enable SMB all the advantages
of using this hardware coupled with Linux thus allowing for a very
budget friendly infrastructure.

lspci -nn (on Dell PowerEdge M520 Blade)
...
01:00.0 RAID bus controller [0104]: LSI Logic / Symbios Logic MegaRAID
SAS 2008 [Falcon] [1000:0073] (rev 03)
08:00.0 RAID bus controller [0104]: LSI Logic / Symbios Logic MegaRAID
SAS 2208 IOV [Thunderbolt] [1000:002f] (rev 05)
...

Sincerely,
--
Istvan Hubay Cebrian
