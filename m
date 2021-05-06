Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD0E4C433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 17:35:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F80F610CE
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 17:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236256AbhEFRg1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 May 2021 13:36:27 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:41749 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236251AbhEFRg1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2021 13:36:27 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 8D51E2EA0DF;
        Thu,  6 May 2021 13:35:28 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id jgVK3MPMd0Yv; Thu,  6 May 2021 13:14:41 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 64EC22EA025;
        Thu,  6 May 2021 13:35:26 -0400 (EDT)
Reply-To: dgilbert@interlog.com
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: [ANNOUNCE] lsscsi release 0.32
To:     SCSI development list <linux-scsi@vger.kernel.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        =?UTF-8?B?VG9tw6HFoSBCxb5hdGVr?= <tbzatek@redhat.com>
Message-ID: <36e52369-4480-a073-d42b-b3e9b8bbbbf0@interlog.com>
Date:   Thu, 6 May 2021 13:35:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

lsscsi is a command line utility that probes sysfs in Linux 2.6, 3,
4 and 5 series kernels in order to list information about SCSI
devices and SCSI hosts. The default format is one device (e.g. disk)
per line. Other storage devices that use the SCSI subsystem such as
SATA disks, USB keys and enclosures are also listed. Release 0.30
added listings of NVMe namespaces (devices) and hosts (controllers)
and that has been further refined in this release.

Release 0.32 is described and is available on these websites:
     https://sg.danny.cz/scsi/lsscsi.html
     https://doug-gilbert.github.io/scsi/lsscsi.html

My subversion lsscsi repository is mirrored in git at:
     https://github.com/doug-gilbert/lsscsi
     https://github.com/hreinecke/lsscsi    [needs updating]

Note: a change in terminology from package "version" to "release".
That allows me to write 'pre-release' in the ChangeLog until I actually
do the release. For example Fedora 34 has a "version 0.32' of lsscsi
which corresponds to the author's subversion revision 164. Hence, for
example, the Fedora 34 lsscsi will not print nr_hw_queues if it is
available; not an ideal situation.

Note 2: All my packages have a CREDITS file where the names of
contributors and what was contributed are listed.


Changelog for released lsscsi-0.32 [20210505] [svn: r167]
   - improve NVMe device parsing (e.g. /dev/nvme0c1n2)
   - print nr_hw_queues when available for SCSI hosts
   - Remove blank line after NVMe device name with -HL
   - collect_disk_wwn_nodes: Fix WWN string copy
   - make WWN printing for NVMe more consistent with
     output from SCSI devices (e.g. with -u and -t)
   - logic to select best SCSI id (--scsi_id) to output
   - clean up warnings for gcc-10
   - build with autoconf 2.70

Changelog for released lsscsi-0.31 [20200220] [svn: r160]
...


Doug Gilbert
