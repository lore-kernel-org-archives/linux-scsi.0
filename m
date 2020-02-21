Return-Path: <SRS0=iCCw=4J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45DCAC35641
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 05:38:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20DAA222C4
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Feb 2020 05:38:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbgBUFiO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Feb 2020 00:38:14 -0500
Received: from smtp.infotech.no ([82.134.31.41]:48813 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbgBUFiO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Feb 2020 00:38:14 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 52A5A204190;
        Fri, 21 Feb 2020 06:38:12 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id SqWLuvmLguZy; Fri, 21 Feb 2020 06:38:04 +0100 (CET)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 4DB692040E4;
        Fri, 21 Feb 2020 06:38:02 +0100 (CET)
Reply-To: dgilbert@interlog.com
To:     SCSI development list <linux-scsi@vger.kernel.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        David Sommerseth <davids@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] lsscsi version 0.31 released
Message-ID: <435f80a2-ab55-9df2-c59c-c1ec113461ff@interlog.com>
Date:   Fri, 21 Feb 2020 00:37:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

lsscsi is a command line utility that probes sysfs in Linux 2.6, 3,
4 and 5 series kernels in order to list information about SCSI
devices and SCSI hosts. The default format is one device (e.g. disk)
per line. Other storage devices that use the SCSI subsystem such as
SATA disks and USB keys are also listed. The previous version (0.30)
added listings of NVMe namespaces (devices)

This version is mainly for bug fixes. Version 0.31 is available at:
     http://sg.danny.cz/scsi/lsscsi.html
More information can be found on that page including examples
plus a Download and Build information section.

ChangeLog:
Version 0.31 2020/02/20 [svn: r160]
   - fix issue where host managed ZBC devices don't
     output their size. [Fix also for RBC and CD/DVD.]
   - exclude NVMe listings when --classic given
   - fix hex counting issues
   - supply "-" for generic NVMe device one line output
     so 'lsscsi -gb' output is consistent
   - cleanup gcc-8 warnings, no cleanup needed for gcc-9

Version 0.30 2018/06/12 [svn: r154]
   - add support for NVMe devices and controllers
   ....


Doug Gilbert

