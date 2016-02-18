From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [Announce] sg3_utils-1.42 available
Date: Thu, 18 Feb 2016 14:52:08 -0500
Message-ID: <56C620E8.4040708@interlog.com>
References: <56C54F9A.80902@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56C54F9A.80902@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: Martin Pitt <mpitt@debian.org>, David Sommerseth <davids@redhat.com>, Hannes Reinecke <hare@suse.de>, Ritesh Raj Sarraf <rrs@researchut.com>, "Robin H. Johnson" <robbat2@gentoo.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 16-02-17 11:59 PM, Douglas Gilbert wrote:
> sg3_utils is a package of command line utilities for sending
> SCSI and some ATA commands to devices. This package targets
> the Linux 4, 3, 2.6 and 2.4 kernel series. It has ports to
> FreeBSD, Tru64, Solaris, and Windows (cygwin and MinGW).
>
> There are two new utilities (sg_read_attr and sg_timestamp)
> and additions to many others, see the ChangeLog below. This
> version tracks various changes made by www.t10.org since May
> 2015 until January 2016.

Missed the links:
For an overview of sg3_utils and downloads see this page:
     http://sg.danny.cz/sg/sg3_utils.html
The sg_ses utility (for enclosure devices) is discussed at:
     http://sg.danny.cz/sg/sg_ses.html
A full changelog can be found at:
     http://sg.danny.cz/sg/p/sg3_utils.ChangeLog

> Changelog for sg3_utils-1.42 [20160217] [svn: r663]
>    - sg_timestamp: new, to report or set timestamp
>    - sg_read_attr: new, supported by tape drives
>    - sg_stpg: fix truncation of target port field
>    - sg_inq: cope with unicode strings, udev fixes
>      - update version descriptor list to 20160125
>      - '--export': new entries for UUID descriptor
>    - sg_ses: add more field acronyms (ses3r11)
>    - sg_logs: add Utilization lpage (sbc4r07)
>      - add Background operation lpage
>      - add Pending defects lpage
>      - add LPS misalignment lpage (sbc4r10)
>      - document '--All' ('-A') option
>      - rework lto tape vendor lpages
>    - sg_vpd: add Block limits extension VPD page
>      - add Device constituents VPD page
>      - add LB Protection VPD page (ssc 15-296r1)
>      - LB provisioning VPD page: expand LBPRZ, add
>        Minimum and Threshold percentage fields
>      - rework lto tape vendor VPD pages
>    - sg_inq+sg_vpd+sg_xcopy: add support for locally
>      assigned UUIDs in VPD page 0x83 (spc5r08)
>    - sg_sanitize: add --znr option (sbc4r07)
>    - sg_rep_zones: add --partial option (zbc-r04)
>    - sg_format: add ffmt option (sbc4r10)
>      - add support for FORMAT MEDIUM (for tape)
>    - sg_raw: document length relationships
>    - rescan-scsi-bus.sh: updates from Suse
>    - sg_lib_data: sync asc/ascq codes with T10 20151126
>    - sg_lib: add 'sense' categories for SCSI statuses:
>      condition met, busy, task set full, ACA active and
>      task aborted
>      - add pr2serr() extern
>      - change sg_get_sense_str() and dStrHexStr(), return
>        chars written (returned void previously)
>      - add sg_get_sense_descriptors_str() function
>      - add sg_get_designation_descriptor_str() function
>      - sg_get_desig_type_str()+sg_get_desig_assoc_str()
>        and sg_get_desig_code_set_str() added
>      - sg_get_opcode_sa_name() break out zoning in/out,
>        read attribute and read position service actions
>    - sg_cmds_extra: add sg_ll_format_unit2() for FFMT
>    - sg_pr2serr.h: new, to shorten fprintf(stderr, ...)
>    - sg_io_linux, sg_pt_linux: drop SUGGEST_* decoding
>    - sg_unaligned.h: add 48 bit support and gets for
>      variable length unsigned integers
>
> Changelog for sg3_utils-1.41 [20150511] [svn: r644]
> ...
>
> Doug Gilbert
