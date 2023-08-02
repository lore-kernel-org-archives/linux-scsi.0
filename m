Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FB93C04A94
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 06:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbjHBGTF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 02:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbjHBGTE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 02:19:04 -0400
X-Greylist: delayed 427 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Aug 2023 23:19:02 PDT
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BF926A2
        for <linux-scsi@vger.kernel.org>; Tue,  1 Aug 2023 23:19:01 -0700 (PDT)
Received: from mailpool-fe-01.fibernetics.ca (mailpool-fe-01.fibernetics.ca [208.85.217.144])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id 12C6876289;
        Wed,  2 Aug 2023 06:11:54 +0000 (UTC)
Received: from localhost (mailpool-mx-01.fibernetics.ca [208.85.217.140])
        by mailpool-fe-01.fibernetics.ca (Postfix) with ESMTP id 070FD3E163;
        Wed,  2 Aug 2023 06:11:54 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-01.fibernetics.ca ([208.85.217.144])
        by localhost (mail-mx-01.fibernetics.ca [208.85.217.140]) (amavisd-new, port 10024)
        with ESMTP id JjbWAzQo0Qm1; Wed,  2 Aug 2023 06:11:53 +0000 (UTC)
Received: from [192.168.48.17] (host-192.252-165-26.dyn.295.ca [192.252.165.26])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id D369C3E160;
        Wed,  2 Aug 2023 06:11:52 +0000 (UTC)
Message-ID: <c30ec9ba-4beb-b948-ac1a-eccc5b8ba49f@interlog.com>
Date:   Wed, 2 Aug 2023 02:11:52 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Reply-To: dgilbert@interlog.com
Content-Language: en-CA
To:     SCSI development list <linux-scsi@vger.kernel.org>
Cc:     =?UTF-8?B?VG9tw6HFoSBCxb5hdGVr?= <tbzatek@redhat.com>,
        Martin Pitt <mpitt@debian.org>, Hannes Reinecke <hare@suse.de>,
        Ritesh Raj Sarraf <rrs@researchut.com>,
        "Robin H. Johnson" <robbat2@gentoo.org>,
        Martin Wilck <mwilck@suse.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] sg3_utils-1.48 available
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sg3_utils is a package of command line utilities for sending SCSI commands
to storage devices. In some contexts it can send ATA and/or NVMe commands.
The package targets the Linux 2.4 and later kernel series. It has ports to
FreeBSD, NetBSD, Android, Solaris, and Windows (cygwin and MinGW).

For an overview of sg3_utils and downloads see either of these pages:
     https://sg.danny.cz/sg/sg3_utils.html
     https://doug-gilbert.github.io/sg3_utils.html
The sg_ses utility (for enclosure devices) is discussed at:
     https://sg.danny.cz/sg/sg_ses.html
A full changelog can be found at:
     https://sg.danny.cz/sg/p/sg3_utils.ChangeLog
     https://doug-gilbert.github.io/p/sg3_utils.ChangeLog
This github mirror needs to be updated:
     https://github.com/hreinecke/sg3_utils
Plus the author's own github mirror:
     https://github.com/doug-gilbert/sg3_utils

That last mirror is up-to-date and has git tags going back to "r1.20"
which is sg3_utils 1.20 released 17 years ago.


Summary Changelog for release sg3_utils-1.48 [20230801] [svn: r1042]
====================================================================
   New utilities:
   --------------
     sg_rem_rest_elem: removing or restoring physical elements
     sg_rep_density: decode report density response (tape)
     sg_sat_datetime: accessing  date/time (S)ATA commands
     sg_write_attr: for write attribute command (tape)
     sg_z_act_query: for zone activate or zone query command

   JSON support:
   -------------
    utilities in this package that decode a significant amount of
    metadata (as defined by T10) now have optional JSON output. The
    default remains plain text output. The long forms of the new JSON
    options are --json[=JO] and -js-file=JFN where the (optional) 'JO'
    is a sequence of JSON one letter options. 'JFN' is a filename into
    which the JSON output will be sent; otherwise JSON output goes to
    stdout. The utilities with JSON support are:
       sg_decode_sense, sg_get_elem_status, sg_get_lba_status, sg_inq,
       sg_logs, sg_luns, sg_opcodes, sg_readcap, sg_rep_zones, sg_ses,
       sg_vpd .
    Snake notation is used for JSON names, similar to sysfs file naming
    conventions (e.g. 'vpd_pg83'). T10 command, page and field names
    are all converted to snake notation when they appear in a JSON name.

   BUILD changes:
   -------------
     All the intermediate build files like configure and Makefile.in
     have been removed. This reduces the size of the source package
     in subversion and git. The downside is that an extra step is
     required at the start of the build process. The canonical form
     is now './autogen.sh ; ./configure ; make ; make install' .
     There is also a 'bootstrap' script that simply calls autogen.sh .
     The official tarballs will contain the intermediate files for
     compatibility with older versions.

   Others changes:
   -------------
   - netbsd: experimental port, scsi only
   - rescan-scsi-bus.sh: lots of fixes and speed ups
   - track additions in recent drafts of SPC-5, SPC-6 and SBC-5
   - expansion of support for the --inhex=HFN option. HFN is a
     filename assumed to contain hex representing the response to
     one or more SCSI commands. The new 'inhex' directory contains
     files of hex data for many utilities in this package.
     Invocation examples are included as comments in those files.
     For example inhex/get_lba_status.hex is response data for
     the sg_get_lba_status utility.


Work in associated packages
===========================
The sg_modes utility in sg3_utils does not decode mode pages. That
chore has been left to the sdparm utility in a package of the same
name. The sdparm utility also has an --inhex= option that can
process data produced by sg_modes. sdparm can also produce JSON
output with the same options as described above: --json[=JO] and
--js-file=JFN .

The lsscsi utility has also been expanded to produce JSON output
with the same two options. In all cases, plain text remains the
default.


Previous release: sg3_utils-1.47 [20211110] [svn: r919]

Douglas Gilbert
1 August 2023
