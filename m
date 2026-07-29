Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BBC3B71CB
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 23:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=208.85.217.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785368412; cv=none; b=dEdW0KHN4NamAuJdVE25PPP9xfKwKx4ctjyhXtykF79FRoLW2txUWjSzoQyHx/eTfO6gJRbpxENOvzB9L/l0KPwrtkDyFECWTvh4EBXJioxm2bCxJKn/Fe/XOOEQ7n9Q/XyrPQGYhK4X7oWozLaUFYQmiFJeG9Hrurf+D8mDAg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785368412; c=relaxed/simple;
	bh=8Z61zFYBCdssi1pnKMoJ4uQT7KqfEPeUtM6+M0pmnKg=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=tgZ6aHZi2rcD73amVVLS9LDWA3SvYkstdLSff+WK+caqwI7uNlIo8t5B49EHSU9/sLTFhBZwWCtFyJ/S4WUlf36/tAT4aANCwTGKc4hPTjvBuMmesgyEiMzvsoWuFyDPaRDLZJgG/URTYYqwVyn0fq1zQu7PDzLwhj0aLJaPTYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=interlog.com; spf=pass smtp.mailfrom=interlog.com; dkim=pass (2048-bit key) header.d=interlog.com header.i=@interlog.com header.b=R2wdUCiS; arc=none smtp.client-ip=208.85.217.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=interlog.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=interlog.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=interlog.com header.i=@interlog.com header.b="R2wdUCiS"
Received: from mailpool-fe-01.fibernetics.ca (mailpool-fe-01.fibernetics.ca [208.85.217.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id 230DB72955;
	Wed, 29 Jul 2026 23:33:43 +0000 (UTC)
Received: from localhost (mailpool-mx-02.fibernetics.ca [208.85.217.141])
	by mailpool-fe-01.fibernetics.ca (Postfix) with ESMTP id 1E90728A5B;
	Wed, 29 Jul 2026 23:33:43 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
X-Spam-Flag: NO
X-Spam-Score: -1.199
X-Spam-Level:
Received: from mailpool-fe-01.fibernetics.ca ([208.85.217.144])
	by localhost (mail-mx-02.fibernetics.ca [208.85.217.141]) (amavisd-new, port 10024)
	with ESMTP id j3z6nClcYudx; Wed, 29 Jul 2026 23:33:42 +0000 (UTC)
Received: from [192.168.48.17] (host-104-157-180-40.dyn.295.ca [104.157.180.40])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dgilbert@interlog.com)
	by mail.ca.inter.net (Postfix) with ESMTPSA id 6CD1B28A5A;
	Wed, 29 Jul 2026 23:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=interlog.com; s=mail;
	t=1785368022; bh=8Z61zFYBCdssi1pnKMoJ4uQT7KqfEPeUtM6+M0pmnKg=;
	h=Date:Reply-To:To:Cc:From:Subject:From;
	b=R2wdUCiS9bdsjD6Tl9OK5FV5opXGig8JRcGd7FFGLKii2iiBJLciPUiuQyowV1mnZ
	 ZOuvCzZ/yPqOSScdR7gVovNpmWh5IY0uhexjSSjwytarydICaU3gr48V48ieRs49DA
	 8js+XMDMoFcgwfFR0g2s3flbk/2R3egB2zFrc8kdGXMm5zo4IeTUqiye5wyE7RFRr/
	 F3K/N9gM01zjs6LvgSxbnfUfIfYMrtwF6lETgyPhe5W/F8nWACm7m+UjAmu/hFLi+Z
	 g1fLapB54qqxmiW8I33enoaplhZY27Mua1GoXSOLMvQSKPMdsyZYKLDNC0cj1Lfryy
	 I/oQJjZ3XjUlA==
Message-ID: <65c9f013-eb13-43bc-a9b1-e98f05e19b26@interlog.com>
Date: Wed, 29 Jul 2026 19:33:40 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: dgilbert@interlog.com
Content-Language: en-CA
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: =?UTF-8?B?VG9tw6HFoSBCxb5hdGVr?= <tbzatek@redhat.com>,
 Martin Pitt "<mpitt@debian.org>" Hannes Reinecke "<hare@suse.de>" Ritesh Raj
 Sarraf "<rrs@researchut.com>" Robin "H." Johnson "<robbat2@gentoo.org>"
 Martin Wilck <mwilck@suse.com>, Paul Evans <pevans@redhat.com>,
 Alan Somers <asomers@freebsd.org>
From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] sg3_utils-1.49 available
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

It has been a while. I no longer maintain the sg and scsi_debug drivers
in the Linux kernel but I do plan to maintain my user space packages.
First among these packages is sg3_utils which is 26 years old (if one
includes when it was part of the older sg_utils package).

For an overview of sg3_utils and downloads see either of these pages:
     https://sg.danny.cz/sg/sg3_utils.html
     https://doug-gilbert.github.io/sg3_utils.html
The sg_ses utility (for enclosure devices) is discussed at:
     https://doug-gilbert.github.io/sg_ses.html
     https://sg.danny.cz/sg/sg_ses.html
A full changelog can be found at:
     https://sg.danny.cz/sg/p/sg3_utils.ChangeLog
     https://doug-gilbert.github.io/p/sg3_utils.ChangeLog
My own github site:
     https://github.com/doug-gilbert/sg3_utils

The last link has a 'release-1.49' tag which shows the state of the code
at the time of release [20260718]. There have been some commits since
then but none that seriously impact Linux. Some of the above pages are
awaiting updates, All the installed utilities and scripts have (or should
have) up to date manpages which are also installed. Those manpages try
to do more that list the command line options, in some cases they try to
explain "why". Some, but not all, manpages have an EXAMPLES section.

One way to report issues is with a patch via the github PR mechanism, or
raise a github Issue. Emailing me directly with a patch attached is also
good. Please note, I am no longer subscribed to this list (nor the
linux-kernel list).

Cmake build infrastructure has been added and the intention is that both
it and GNU Autotools generate the same outputs (easier said than
done). Cmake's CTest looks interesting (but has not been "wired" yet)
while cpack is functional and very useful.

The ChangeLog is long, so it has been broken into 2 parts, the first part
has utility specific changes, listed in alphabetical order. The second part
contains more general changes: to the common library or the build scripts.
The github log messages often supply more information (than a one line
summary). Note that subversion is lurking in the background with simple to
follow concepts like ascending integers for revision numbers (e.g. r1133)



ChangeLog for release sg3_utils-1.49 [20260718] [svn: r1133]
   Utility specific changes:
   - rescan-scsi-bus.sh: fix multipath resize without update
     https://github.com/doug-gilbert/sg3_utils/pull/43.diff
     and 44.diff
     - fix for github.com/doug-gilbert/sg3_utils/issues/46
     - github PR numbers: 68, 69, 71 and 74 by Paul Evans
     - github pull req: #72 fix udevadm invocation M. Wilck
     - github issue: #76 fix shellcheck warnings Xose Vazquez Perez
   - scsi_logging_level: add MIT license Xose Vazquez Perez
   - scsi-rescan.8 manpage added, links to rescan-scsi-bus.8
   - sg_copy_results: part of github PR #74
   - sg_dd: add grpnum=GN operand and --nocopy option
   - sg_get_elem_status: fractional elements, sbc6r02
     - correct several error messages
   - sg_get_lba_status: additional LBA accessibility values
   - sginfo: part of github PR #74
   - sg_inq: update version descriptors to T10 table 20230814
     - re-introduce the --ata option, hidden since rel 1.43
   - sg_inq+sg_vpd: show depopulation time in hours and
     minutes as well as its raw form: seconds
     - add RSCS field to Block limits extension vpd page [sbc5r5]
     - translation of NVMe FR field uses sg_last_n_non_blank()
     - add NVMe Information VPD page
     - clean up ATA Information VPD page
     - rework designation descriptor handling
     - sg_inq --export conformance for SCSI name string
       by Paul Evans github PR #83
   - sg_lib: add sg_last_n_non_blank() for SNT FR field
     - sg_lib.[hc] add sg_strscpy() to replace strncpy()
     - sg_json.c fixes from lsscsi project pull #15
     - sg_json.[hc] add sgj_haj_vs_hex_bytes_nex() for
       outputting IDs as ASCII hex strings
     - sg_json.[hc] add sgj_haj_vs_len()
     - sg_json.[hc] add sgj_haj_vs_nex()
     - sg_json_sg_lib.[hc] sgj_js_designation_descriptor()
       changed to sgj_haj_designation_descriptor()
   - sg_logs: correct tape Device statistics lpage [0x14]
     serial number parameters [0x40 and 0x41] per
     https://github.com/doug-gilbert/sg3_utils/issues/45
   - sg_map: handle LUNs > 255
   - sg_opcodes: fix rwcdl/cdlp fields handling D. Le Moal
   - sg_rem_rest_elem: add support for REMOVE ELEMENT AND
   - MODIFY ZONES command, Damien Le Moal
   - sg_requests: improve buffer truncation
   - sg_sat_read_gplog: list names of supported GP log addresses
   - sg_ses: restore some help text, github PR #79 Paul Evans
   - sg_stream_ctl: add --hex, --inhex=, --json= and --raw
     options; additions in sbc5r05 (perm and relative_lifetime
     fields).
   - sg_turs: fix missing CDB on several codepaths
   - sg_vpd: inform about SPC-6 (sg_inq knew already)
     https://github.com/doug-gilbert/sg3_utils/issues/40
     - add --descriptors option, for version descriptors
     - part of github PR #74
     - some sg_vpd fixes shown under sg_inq+sg_vpd entry above
   - sg_wr_mode: fix --contents and --cfile= handling
     - add --mfile=MF option for decoding mask in the MF file
     - fix introduced Makefile.am bug, plus only for Linux
   - sg_xcopy: part of github PR #74
   - utils/hxascdmp: sprint -> snprintf [github PR #78]

   General changes:
   - fix 'make distcheck' (again)
   - add cmake build system (alongside autotools) with cpack
     for deb and rpm packages; ctest not wired yet
     - github PR #80 by Alan Somers which is associated
       with cpack FreeBSD settings
     - github PR #82 by Paul Evans to get cmake output to be
       equivalent (in parity) with what Autotools produces
     - wire option(DISABLE_LIBSGUTILS (def: OFF)) so when
       ON sgutils2 library is static but other libraries
       are shared objects (e.g. libc.so)
     - github PR #84 by Paul Evans to fix cpack generated
       Debian dev library path, needed by sdparm and ddpt
   - retire all uses of lseek64() as _FILE_OFFSET_BITS=64
     compile define should take care of older 32 bit cases
   - fixes so musl-gcc builds clean
   - start complying with T10 23-047r1 "Broadcom SNT Reference"
     document assuming T10 SNT drafts are coming
   - rearrange SNT and NVMe headers and associated source
   - new error code: SG_LIB_PROGRESS_NOT_READY for long
     duration 'in progress' additional sense codes
   - lib/sg_pt_solaris.c : fix compilation issue per
     https://github.com/doug-gilbert/sg3_utils/pull/41
   - lib/sgj_haj_*() functions: tweak hex_haj argument meaning
   - scripts/00-scsi-sg3_config.rules : apply
     https://github.com/doug-gilbert/sg3_utils/pull/42
   - rename build_debian.sh script to debian_build.sh
   - rename testing directory to ttesting to avoid clash with
     cmake's CTEST that creates a Testing directory
   - ttesting/sg_chk_inq_vd.c: test internal table against T10
     version descriptor file
   - check/clean against gcc-16 -fanalyzer; clang-22 --analyze
   - debian build: modernize with dh sequencer [github PR# 73]
   - AIX partial support: needs getopt.h header which
     surprisingly is non-standard. Keep hidden version in
     lib directory and copy to include dir as needed
      - still no real pass-through, using sg_dummy instead
   - getopt_long directory contents -> lib directory
   - JSON: make output more consistent so most command
     responses have a *_parameter_data or similar sub-object
   - apply https://github.com/doug-gilbert/sg3_utils/pull/39
     and its revision [20230807] mainly for Android


Changelog for released sg3_utils-1.48 [20230801] [svn: r1042]
    .....


Douglas Gilbert


