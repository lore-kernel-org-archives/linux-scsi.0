From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [Announce] sg3_utils-1.38 available
Date: Thu, 03 Apr 2014 00:51:21 -0400
Message-ID: <533CE8C9.9050609@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: =?ISO-8859-1?Q?Dan_Hor=E1k?= <dhorak@redhat.com>, Ritesh Raj Sarraf <rrs@researchut.com>, "Robin H. Johnson" <robbat2@gentoo.org>, Martin Pitt <mpitt@debian.org>, Hannes Reinecke <hare@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

sg3_utils is a package of command line utilities for sending
SCSI and some ATA commands to devices. This package targets
the Linux 3, 2.6 and 2.4 kernel series. It also has ports to
FreeBSD, Tru64, Solaris, and Windows (cygwin and MinGW).

Users of sg_xcopy note that the default recipient of the
xcopy(lid1) command has changed from the source to the
destination device. An environment variable [XCOPY_TO_SRC] can
re-instate the previous default. This version tracks various
changes made by www.t10.org since October 2013.

For an overview of sg3_utils and downloads see this page:
     http://sg.danny.cz/sg/sg3_utils.html
The sg_ses utility (for enclosure devices) is discussed at:
     http://sg.danny.cz/sg/sg_ses.html
A full changelog can be found at:
     http://sg.danny.cz/sg/p/sg3_utils.ChangeLog

A release announcement will be sent to freecode.com .

Changelog for sg3_utils-1.38 [20140401] [svn: r563]
   - sg_ses: add --dev-slot-num= and --sas-addr=
     - fix --data=- problem with large buffers
     - new --data=@FN to read hex data from file FN
     - error and warning message cleanup
     - add --maxlen= option
   - sg_inq: add --block=0|1 option to control opens
     - add --inhex=FN to read response in ASCII hex from
       a file; --inhex=FN --raw reads response in binary
     - make -HHH (-HHHH for '-p ai') output suitable for
       another sg_inq invocation to use --inhex to decode
     - add LU_CONG to standard inquiry response output
     - decode ASCII information VPD pages
     - add HAW_ZBC in block dev char. VPD page (sbc4r01)
     - sync version descriptors dated 20131126
     - allow --page=-1 to force std INQUIRY decoding
     - fix overflow in encode_whitespaces
     - improve unit serial number display (VPD page 0x80)
   - sg_vpd: add LU_CONG to standard inquiry response output
     - add --inhex=FN to read response in ASCII hex from
       a file; --inhex=FN --raw reads response in binary
     - decode Third Party Copy (tpc) page
     - add HAW_ZBC in block dev char. VPD page (sbc4r01)
     - add LTO and DDS vendor pages
     - allow --page=num to restrict --enumerate output
   - sg_persist: add PROUT: Replace Lost Reservation (spc4r36)
     - add --transport-id= for SOP: 'sop,<routing_id_in_hex>'
   - sg_readcap: for --16 show physical block size if
     different from logical block size
   - sg_xcopy: environment variables: XCOPY_TO_SRC and
     XCOPY_TO_DST indicate where xcopy command is sent
     - change default to send xcopy to dst (was src)
     - improve CL handling of short options (e.g. '-vv')
   - sg_luns: guard against garbage response
   - sg_decode_sense: with --nospace ignore spaces on
     command line, so multiple arguments are concatenated
   - sg_write_same: repeat if unit attention
   - sg_rtpg: fix indexing bug with --extended option
   - sg_logs: placeholder for pending defects lpage
   - sg_unmap: fix another problem with --grpnum= option
   - sg_lib.h: add PDT_ZBC define (spc4r36p)
   - sg_lib_data: sync asc/ascq codes with T10 dated 20140320
     - add pdt string for ZBC (spc4r36p)
   - sg_lib: extensions to sg_get_num() and sg_get_llnum()
   - sg_cmds_extra: fix sa bug in sg_ll_3party_copy_out()
   - scripts/rescan-scsi-bus.sh: check if FC driver exports
     issue_lip before using it
     - man page added (Linux only)
   - scripts/59-scsi-sg3_utils.rules: linux specific udev rules
   - examples: add sg_tst_excl3 for testing O_EXCL
     - improve sg_tst_excl and sg_tst_excl2
     - add sg_tst_context for testing file handle contexts
   - upgrade automake to version 1.13.3
   - add suse directory and 'spec' file to facilitate builds

Changelog for sg3_utils-1.37 [20131014] [svn: r522]
...

Doug Gilbert
