From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] smp_utils-0.96 available
Date: Wed, 22 Jun 2011 22:13:23 -0400
Message-ID: <4E02A143.1090306@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:34209 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758245Ab1FWCNy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2011 22:13:54 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp.infotech.no (Postfix) with ESMTP id 1BE9D30ED7
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2011 04:13:50 +0200 (CEST)
Received: from smtp.infotech.no ([127.0.0.1])
	by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2L2uQDaQp+PG for <linux-scsi@vger.kernel.org>;
	Thu, 23 Jun 2011 04:13:50 +0200 (CEST)
Received: from [10.7.0.6] (unknown [10.7.0.6])
	by smtp.infotech.no (Postfix) with ESMTPA id 96DD230E93
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2011 04:13:49 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

smp_utils is a package of command line utilities for invoking
SMP functions to monitor and manage SAS expanders. SMP is the
Serial Attached SCSI (SAS) Management Protocol. A SAS Host
Bus Adapter (HBA) includes a SMP initiator (along with SSP and
STP initiators). A SAS expander contains a SMP target. Many
SAS HBAs have a SMP pass through interface that can be used to
send SMP requests and receive the responses. This package is
designed to work with the linux kernel (lk) 2.6 series.

Two interfaces are available: "sgv4" and "mptctl".
The "sgv4" interface uses the bsg driver.

This version is a major upgrade, adding 14 new functions most
of which are for SAS-2 zoning.

For an overview and examples of smp_utils see:
http://sg.danny.cz/sg/smp_utils.html

Changelog for smp_utils-0.96 [20110620] [svn:r96]
   - smp_conf_zone_perm_tbl, smp_conf_zone_man_pass
     smp_conf_zone_phy_info, smp_ena_dis_zoning,
     smp_rep_broadcast, smp_rep_phy_event, smp_rep_phy_event_list,
     smp_rep_self_conf_stat, smp_rep_zone_man_pass,
     smp_rep_zone_perm_tbl, smp_zone_activate, smp_zoned_broadcast,
     smp_zone_lock, smp_zone_unlock:
       add these new utilities
   - all utilities: sync to SPL-2 (spl2r01)
     -those with '--phy=ID' option: increase max from 128 to 254
   - smp_discover, smp_discover_list: add --adn and --summary
     - make --summary default if --phy=ID option not given
     - with --summary show disabled and errored phys
   - smp_discover: add --my and --zero option
   - smp_discover_list: add --zpi=FN option
   - smp_rep_general, smp_rep_manufacturer, smp_rep_phy_err_log,
     smp_rep_phy_sata: add --zero options
   - smp_conf_general: add --power option
   - smp_read_gpio, smp_write_gpio: add --enhanced option
   - add examples directory, mainly for zoning
   - remove doc/smp_utils.html , refer readers to web page
   - remove tpl (ai) interface


SAS-2 expanders often include a SCSI Enclosure Services (SES)
device. To support this there has been a major rework of the
sg_ses utility in the sg3_utils package. A beta of sg3_utils
1.32 is available at http://sg.danny.cz/sg/sg3_utils.html

Doug Gilbert
