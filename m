Return-Path: <SRS0=THiH=4V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBC6C3F2D1
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 19:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 132032146E
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 19:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388237AbgCDTGg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Mar 2020 14:06:36 -0500
Received: from mailout.easymail.ca ([64.68.200.34]:60886 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729600AbgCDTGg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2020 14:06:36 -0500
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Mar 2020 14:06:33 EST
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id 1B001A0550;
        Wed,  4 Mar 2020 18:58:35 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo05-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo05-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nEF_PjvgL5VP; Wed,  4 Mar 2020 18:58:34 +0000 (UTC)
Received: from mail.gonehiking.org (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        by mailout.easymail.ca (Postfix) with ESMTPA id 2B2BDA009C;
        Wed,  4 Mar 2020 18:58:25 +0000 (UTC)
Received: from [192.168.1.4] (rhapsody.internal [192.168.1.4])
        by mail.gonehiking.org (Postfix) with ESMTP id 744733EFD9;
        Wed,  4 Mar 2020 11:58:24 -0700 (MST)
Subject: Re: [PATCH 11/42] docs: scsi: convert BusLogic.txt to ReST
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <cover.1583136624.git.mchehab+huawei@kernel.org>
 <750629b6a5233c85c5391c44d126606b8aabefc8.1583136624.git.mchehab+huawei@kernel.org>
From:   Khalid Aziz <khalid@gonehiking.org>
Autocrypt: addr=khalid@gonehiking.org; prefer-encrypt=mutual; keydata=
 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
Message-ID: <d50894cd-ef7e-7508-cf1e-363b6a0c7620@gonehiking.org>
Date:   Wed, 4 Mar 2020 11:58:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <750629b6a5233c85c5391c44d126606b8aabefc8.1583136624.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/2/20 1:15 AM, Mauro Carvalho Chehab wrote:
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  .../scsi/{BusLogic.txt => BusLogic.rst}       | 89 +++++++++++++------
>  Documentation/scsi/index.rst                  |  1 +
>  drivers/scsi/BusLogic.c                       |  2 +-
>  drivers/scsi/Kconfig                          |  2 +-
>  4 files changed, 67 insertions(+), 27 deletions(-)
>  rename Documentation/scsi/{BusLogic.txt => BusLogic.rst} (93%)


Acked-by: Khalid Aziz <khalid@gonehiking.org>

--
Khalid

> 
> diff --git a/Documentation/scsi/BusLogic.txt b/Documentation/scsi/BusLogic.rst
> similarity index 93%
> rename from Documentation/scsi/BusLogic.txt
> rename to Documentation/scsi/BusLogic.rst
> index 48e982cd6fe7..b60169812358 100644
> --- a/Documentation/scsi/BusLogic.txt
> +++ b/Documentation/scsi/BusLogic.rst
> @@ -1,6 +1,11 @@
> -	   BusLogic MultiMaster and FlashPoint SCSI Driver for Linux
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=========================================================
> +BusLogic MultiMaster and FlashPoint SCSI Driver for Linux
> +=========================================================
>  
>  			 Version 2.0.15 for Linux 2.0
> +
>  			 Version 2.1.15 for Linux 2.1
>  
>  			      PRODUCTION RELEASE
> @@ -8,13 +13,16 @@
>  				17 August 1998
>  
>  			       Leonard N. Zubkoff
> +
>  			       Dandelion Digital
> +
>  			       lnz@dandelion.com
>  
>  	 Copyright 1995-1998 by Leonard N. Zubkoff <lnz@dandelion.com>
>  
>  
> -				 INTRODUCTION
> +Introduction
> +============
>  
>  BusLogic, Inc. designed and manufactured a variety of high performance SCSI
>  host adapters which share a common programming interface across a diverse
> @@ -86,9 +94,11 @@ Contact information for offices in Europe and Japan is available on the Web
>  site.
>  
>  
> -				DRIVER FEATURES
> +Driver Features
> +===============
>  
> -o Configuration Reporting and Testing
> +Configuration Reporting and Testing
> +-----------------------------------
>  
>    During system initialization, the driver reports extensively on the host
>    adapter hardware configuration, including the synchronous transfer parameters
> @@ -130,7 +140,8 @@ o Configuration Reporting and Testing
>      The status of Wide Negotiation, Disconnect/Reconnect, and Tagged Queuing
>      are reported as "Enabled", Disabled", or a sequence of "Y" and "N" letters.
>  
> -o Performance Features
> +Performance Features
> +--------------------
>  
>    BusLogic SCSI Host Adapters directly implement SCSI-2 Tagged Queuing, and so
>    support has been included in the driver to utilize tagged queuing with any
> @@ -150,7 +161,8 @@ o Performance Features
>    queue depth of 1 is selected.  Tagged queuing is also disabled for individual
>    target devices if disconnect/reconnect is disabled for that device.
>  
> -o Robustness Features
> +Robustness Features
> +-------------------
>  
>    The driver implements extensive error recovery procedures.  When the higher
>    level parts of the SCSI subsystem request that a timed out command be reset,
> @@ -174,7 +186,8 @@ o Robustness Features
>    lock up or crash, and thereby allowing a clean shutdown and restart after the
>    offending component is removed.
>  
> -o PCI Configuration Support
> +PCI Configuration Support
> +-------------------------
>  
>    On PCI systems running kernels compiled with PCI BIOS support enabled, this
>    driver will interrogate the PCI configuration space and use the I/O port
> @@ -184,19 +197,22 @@ o PCI Configuration Support
>    used to disable the ISA compatible I/O port entirely as it is not necessary.
>    The ISA compatible I/O port is disabled by default on the BT-948/958/958D.
>  
> -o /proc File System Support
> +/proc File System Support
> +-------------------------
>  
>    Copies of the host adapter configuration information together with updated
>    data transfer and error recovery statistics are available through the
>    /proc/scsi/BusLogic/<N> interface.
>  
> -o Shared Interrupts Support
> +Shared Interrupts Support
> +-------------------------
>  
>    On systems that support shared interrupts, any number of BusLogic Host
>    Adapters may share the same interrupt request channel.
>  
>  
> -			    SUPPORTED HOST ADAPTERS
> +Supported Host Adapters
> +=======================
>  
>  The following list comprises the supported BusLogic SCSI Host Adapters as of
>  the date of this document.  It is recommended that anyone purchasing a BusLogic
> @@ -205,6 +221,7 @@ that it is or will be supported.
>  
>  FlashPoint Series PCI Host Adapters:
>  
> +=======================	=============================================
>  FlashPoint LT (BT-930)	Ultra SCSI-3
>  FlashPoint LT (BT-930R)	Ultra SCSI-3 with RAIDPlus
>  FlashPoint LT (BT-920)	Ultra SCSI-3 (BT-930 without BIOS)
> @@ -214,15 +231,19 @@ FlashPoint LW (BT-950)	Wide Ultra SCSI-3
>  FlashPoint LW (BT-950R)	Wide Ultra SCSI-3 with RAIDPlus
>  FlashPoint DW (BT-952)	Dual Channel Wide Ultra SCSI-3
>  FlashPoint DW (BT-952R)	Dual Channel Wide Ultra SCSI-3 with RAIDPlus
> +=======================	=============================================
>  
>  MultiMaster "W" Series Host Adapters:
>  
> +=======     ===		==============================
>  BT-948	    PCI		Ultra SCSI-3
>  BT-958	    PCI		Wide Ultra SCSI-3
>  BT-958D	    PCI		Wide Differential Ultra SCSI-3
> +=======     ===		==============================
>  
>  MultiMaster "C" Series Host Adapters:
>  
> +========    ====	==============================
>  BT-946C	    PCI		Fast SCSI-2
>  BT-956C	    PCI		Wide Fast SCSI-2
>  BT-956CD    PCI		Wide Differential Fast SCSI-2
> @@ -232,9 +253,11 @@ BT-757C	    EISA	Wide Fast SCSI-2
>  BT-757CD    EISA	Wide Differential Fast SCSI-2
>  BT-545C	    ISA		Fast SCSI-2
>  BT-540CF    ISA		Fast SCSI-2
> +========    ====	==============================
>  
>  MultiMaster "S" Series Host Adapters:
>  
> +=======     ====	==============================
>  BT-445S	    VLB		Fast SCSI-2
>  BT-747S	    EISA	Fast SCSI-2
>  BT-747D	    EISA	Differential Fast SCSI-2
> @@ -244,11 +267,14 @@ BT-545S	    ISA		Fast SCSI-2
>  BT-542D	    ISA		Differential Fast SCSI-2
>  BT-742A	    EISA	SCSI-2 (742A revision H)
>  BT-542B	    ISA		SCSI-2 (542B revision H)
> +=======     ====	==============================
>  
>  MultiMaster "A" Series Host Adapters:
>  
> +=======     ====	==============================
>  BT-742A	    EISA	SCSI-2 (742A revisions A - G)
>  BT-542B	    ISA		SCSI-2 (542B revisions A - G)
> +=======     ====	==============================
>  
>  AMI FastDisk Host Adapters that are true BusLogic MultiMaster clones are also
>  supported by this driver.
> @@ -260,9 +286,11 @@ list.  The retail kit includes the bare board and manual as well as cabling and
>  driver media and documentation that are not provided with bare boards.
>  
>  
> -			 FLASHPOINT INSTALLATION NOTES
> +FlashPoint Installation Notes
> +=============================
>  
> -o RAIDPlus Support
> +RAIDPlus Support
> +----------------
>  
>    FlashPoint Host Adapters now include RAIDPlus, Mylex's bootable software
>    RAID.  RAIDPlus is not supported on Linux, and there are no plans to support
> @@ -273,7 +301,8 @@ o RAIDPlus Support
>    than RAIDPlus, so there is little impetus to include RAIDPlus support in the
>    BusLogic driver.
>  
> -o Enabling UltraSCSI Transfers
> +Enabling UltraSCSI Transfers
> +----------------------------
>  
>    FlashPoint Host Adapters ship with their configuration set to "Factory
>    Default" settings that are conservative and do not allow for UltraSCSI speed
> @@ -287,12 +316,14 @@ o Enabling UltraSCSI Transfers
>    the "Optimum Performance" settings are loaded.
>  
>  
> -		      BT-948/958/958D INSTALLATION NOTES
> +BT-948/958/958D Installation Notes
> +==================================
>  
>  The BT-948/958/958D PCI Ultra SCSI Host Adapters have some features which may
>  require attention in some circumstances when installing Linux.
>  
> -o PCI I/O Port Assignments
> +PCI I/O Port Assignments
> +------------------------
>  
>    When configured to factory default settings, the BT-948/958/958D will only
>    recognize the PCI I/O port assignments made by the motherboard's PCI BIOS.
> @@ -312,7 +343,8 @@ o PCI I/O Port Assignments
>    possible future I/O port conflicts.  The older BT-946C/956C/956CD also have
>    this configuration option, but the factory default setting is "Primary".
>  
> -o PCI Slot Scanning Order
> +PCI Slot Scanning Order
> +-----------------------
>  
>    In systems with multiple BusLogic PCI Host Adapters, the order in which the
>    PCI slots are scanned may appear reversed with the BT-948/958/958D as
> @@ -339,7 +371,8 @@ o PCI Slot Scanning Order
>    so as to recognize the host adapters in the same order as they are enumerated
>    by the host adapter's BIOS.
>  
> -o Enabling UltraSCSI Transfers
> +Enabling UltraSCSI Transfers
> +----------------------------
>  
>    The BT-948/958/958D ship with their configuration set to "Factory Default"
>    settings that are conservative and do not allow for UltraSCSI speed to be
> @@ -353,7 +386,8 @@ o Enabling UltraSCSI Transfers
>    "Optimum Performance" settings are loaded.
>  
>  
> -				DRIVER OPTIONS
> +Driver Options
> +==============
>  
>  BusLogic Driver Options may be specified either via the Linux Kernel Command
>  Line or via the Loadable Kernel Module Installation Facility.  Driver Options
> @@ -520,30 +554,34 @@ The following examples demonstrate setting the Queue Depth for Target Devices
>  Devices on the second host adapter to 31, and the Bus Settle Time on the
>  second host adapter to 30 seconds.
>  
> -Linux Kernel Command Line:
> +Linux Kernel Command Line::
>  
>    linux BusLogic=QueueDepth:[,7,15];QueueDepth:31,BusSettleTime:30
>  
> -LILO Linux Boot Loader (in /etc/lilo.conf):
> +LILO Linux Boot Loader (in /etc/lilo.conf)::
>  
>    append = "BusLogic=QueueDepth:[,7,15];QueueDepth:31,BusSettleTime:30"
>  
> -INSMOD Loadable Kernel Module Installation Facility:
> +INSMOD Loadable Kernel Module Installation Facility::
>  
>    insmod BusLogic.o \
>        'BusLogic="QueueDepth:[,7,15];QueueDepth:31,BusSettleTime:30"'
>  
> -NOTE: Module Utilities 2.1.71 or later is required for correct parsing
> +
> +.. Note::
> +
> +      Module Utilities 2.1.71 or later is required for correct parsing
>        of driver options containing commas.
>  
>  
> -			      DRIVER INSTALLATION
> +Driver Installation
> +===================
>  
>  This distribution was prepared for Linux kernel version 2.0.35, but should be
>  compatible with 2.0.4 or any later 2.0 series kernel.
>  
>  To install the new BusLogic SCSI driver, you may use the following commands,
> -replacing "/usr/src" with wherever you keep your Linux kernel source tree:
> +replacing "/usr/src" with wherever you keep your Linux kernel source tree::
>  
>    cd /usr/src
>    tar -xvzf BusLogic-2.0.15.tar.gz
> @@ -557,7 +595,8 @@ Then install "arch/x86/boot/zImage" as your standard kernel, run lilo if
>  appropriate, and reboot.
>  
>  
> -		      BUSLOGIC ANNOUNCEMENTS MAILING LIST
> +BusLogic Announcements Mailing List
> +===================================
>  
>  The BusLogic Announcements Mailing List provides a forum for informing Linux
>  users of new driver releases and other announcements regarding Linux support
> diff --git a/Documentation/scsi/index.rst b/Documentation/scsi/index.rst
> index d453fb3f1f7d..6bb2428c1d56 100644
> --- a/Documentation/scsi/index.rst
> +++ b/Documentation/scsi/index.rst
> @@ -15,5 +15,6 @@ Linux SCSI Subsystem
>     aic7xxx
>     bfa
>     bnx2fc
> +   BusLogic
>  
>     scsi_transport_srp/figures
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index 3170b295a5da..9b8be4f0da19 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -3652,7 +3652,7 @@ static bool __init blogic_parse(char **str, char *keyword)
>    selected host adapter.
>  
>    The BusLogic Driver Probing Options are described in
> -  <file:Documentation/scsi/BusLogic.txt>.
> +  <file:Documentation/scsi/BusLogic.rst>.
>  */
>  
>  static int __init blogic_parseopts(char *options)
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 18af62594bc0..5ec7330f82b6 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -502,7 +502,7 @@ config SCSI_BUSLOGIC
>  	  This is support for BusLogic MultiMaster and FlashPoint SCSI Host
>  	  Adapters. Consult the SCSI-HOWTO, available from
>  	  <http://www.tldp.org/docs.html#howto>, and the files
> -	  <file:Documentation/scsi/BusLogic.txt> and
> +	  <file:Documentation/scsi/BusLogic.rst> and
>  	  <file:Documentation/scsi/FlashPoint.txt> for more information.
>  	  Note that support for FlashPoint is only available for 32-bit
>  	  x86 configurations.
> 

