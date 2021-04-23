Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D872DC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 16:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1FBB61006
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 16:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhDWQ5P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 12:57:15 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:40275 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbhDWQ5P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Apr 2021 12:57:15 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 666B12EA007;
        Fri, 23 Apr 2021 12:56:38 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id OQKsFu1wvmGe; Fri, 23 Apr 2021 12:36:42 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id E0BA02EA19E;
        Fri, 23 Apr 2021 12:56:35 -0400 (EDT)
Reply-To: dgilbert@interlog.com
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] sdparm 1.12 available
To:     SCSI development list <linux-scsi@vger.kernel.org>
Cc:     Tomas Fasth <tomfa@debian.org>, Martin Pitt <mpitt@debian.org>,
        =?UTF-8?B?VG9tw6HFoSBCxb5hdGVr?= <tbzatek@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Ritesh Raj Sarraf <rrs@researchut.com>,
        "Robin H. Johnson" <robbat2@gentoo.org>
Message-ID: <af2547f1-33af-fa26-3242-17a60b331b86@interlog.com>
Date:   Fri, 23 Apr 2021 12:56:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sdparm is a command line utility designed to get and set SCSI device
parameters (cf hdparm for ATA disks). The parameters are held in
mode pages. Apart from SCSI devices (e.g. disks, tapes and enclosures)
sdparm can be used on any device that uses a SCSI command set. sdparm
also can decode VPD pages including the device identification page.
Commands to start and stop the media; load and unload removable media
and some other housekeeping functions are supported. sdparm supports
the Linux kernel 2.6, 3, 4 and 5 series with ports to FreeBSD, Solaris,
Android and Windows.

For more information and downloads see:
     https://sg.danny.cz/sg/sdparm.html   or
     https://doug-gilbert.github.io/sdparm.html

There is a tagged github mirror (of my subversion repository) at:
     https://github.com/doug-gilbert/sdparm


ChangeLog for released sdparm-1.12 [20210421] [svn: r347]
   - add Command duration limits T2A and T2B mpages
   - add Sequestered command fields in Control extension mpage
   - SAS/SPL disconnect-reconnect mpage: BILUNIT and CTLUNIT
     fields added (21-021r3)
   - vpd: SCSI Feature Sets [0x92]: add ZBC feature sets
   - add SAT ATA Feature control mpage (20-085r4)
   - block device char vpd page: add zoned strings
   - expand Out of band management control mpage (spl5r08)
   - vpd: add Format presets and Concurrent positioning
     ranges pages
   - vpd: standard inquiry: add hot_pluggable field
   - sg_lib: allows access to cache mpage's WCE for nvme
   - start using autoconf 2.70
   - point svn:externals to sg3_utils release 1.46 (rev 891)

ChangeLog for sdparm-1.11 [20200303] [svn: r334]
...


An experimental feature noted in the ChangeLog is the ability
to set and clear WCE (write cache enable) on a NVMe disk. More
NVMe support may creep in on a as needed basis in the future.
And 'sdparm -i <nvme_ns>' will output NVMe device identification
data formatted in the same fashion as the SCSI Device
Identification VPD page.

Doug Gilbert
