From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [ANNOUNCE] lio-core-backports.git tree now available!
Date: Mon, 12 Jul 2010 13:31:45 -0700
Message-ID: <1278966705.16667.209.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: nab@risingtidesystems.com
List-Id: linux-scsi@vger.kernel.org

This is a quick resend to fix the subject line so that the ANNOUNCE bots
on LKML correctly pick up this thread.

-----------------------------------------------------------------------

Greetings all,

It is my pleasure to announce that the lio-core-backports.git tree
containing the LIO v3.1.x 'out of tree' kernel module builds is now
publicaly available!  This tree allows the LIO code to run on any
unmodified kernel from recent v2.6.3[1,2] stable kernels that are
shipping with RHEL6, OpenSuse 11 and Ubuntu Lucid Lynx going back to
v2.6.18 w/ RHEL5.  The code is available via gitweb at:

http://risingtidesystems.com/git/?p=lio-core-backports.git;a=summary

This tree has been maintained for the last 8 months tracking upstream
lio-core-2.6.git changes for Rising Tide Systems customers, and is now
being made available as a service to the community.

This tree contains the v3.1.x code for TCM/ConfigFS (Target_Core_Mod)
and the LIO-Target iSCSI fabric module.  This tree also includes a
backport of the configfs filesystem, which is required in order for LIO
to run on pre v2.6.27 kernels due to bugs in the handling of config
subsystem in logic the original fs/configfs code that was fixed upstream
fall 2008.  Finally, the tree is capable of generating RPM and DEB
kernel packages on many propular distributions.

This tree contains complete support of all SPC-4 feature bits for
Persistent Reservations and ALUA multipath.  This same logic has been
certified for VMWare VSphere v4 from multiple independent hardware
vendors who are now shipping LIO v3.x code.

Information has been added to LIO wiki download page at:

http://linux-iscsi.org/index.php/Downloads

and build README containing the mini-HOWTO is available here:

http://risingtidesystems.com/git/?p=lio-core-backports.git;a=blob_plain;f=README;hb=HEAD

Best,

--nab
