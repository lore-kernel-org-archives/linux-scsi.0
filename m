From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [ANNOUNCE]: Emulex SCST support for 16Gb/s FC and FCoE CNAs
Date: Wed, 04 Sep 2013 22:21:21 -0700
Message-ID: <522814D1.100@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I'm glad to announce that SCST support for 16Gb/s FC and FCoE Emulex CNAs is now
available as part of the Emulex OneCore Storage SDK tool set based on the Emulex SLI-4
API. Support for 16Gb/s Fibre Channel LPe16000 series and FCoE hardware using target
mode versions of the OneConnect FCoE CNAs is included. Documented for use with
RHEL/CentOS 6.x based distributions, ocs_fc_scst works with the stable SCST 2.2.1 as
well as the development versions of 2.2.x and 3.0.x. The driver code and documentation
are available on the Emulex web site at:
http://www.emulex.com/products/onecore-storage-software-development-kit/overview.html

Registration is required on the Developer Portal, but this is free.

Questions regarding this driver better to ask via the Developer Portal.

SCST is SCSI target mode stack for Linux. SCST allows creation of sophisticated storage
devices, which provide advanced functionality, like replication, thin provisioning,
deduplication, high availability, automatic backup, etc. Majority of recently developed
SAN appliances, especially higher end ones, are SCST based. It might well be that your
favorite storage appliance running SCST in the firmware.

More info about SCST and its modules you can find on: http://scst.sourceforge.net

Vlad
