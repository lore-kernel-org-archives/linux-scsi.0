From: christophe varoqui <christophe.varoqui@free.fr>
Subject: [ANNOUNCE] multipath-tools-0.4.2
Date: Mon, 24 Jan 2005 00:03:16 +0100
Message-ID: <1106521396.10990.13.camel@zezette>
References: <1096071849.4466.31.camel@zezette>
	<1097054573.4163b96d1262c@imp5-q.free.fr>
	<1097495416.416a73787e0ae@imp1-q.free.fr>
	<1098021787.5433.8.camel@zezette>
	<1098269169.417641f18a234@imp1-q.free.fr>
	<1098656088.9350.88.camel@zezette>
	<1098785191.417e21a7a7c28@imp1-q.free.fr>
	<1099328918.5525.10.camel@zezette> <1100214617.10251.92.camel@zezette>
	<1101394541.5820.71.camel@zezette> <1102261392.29843.2.camel@zezette>
	<1103558483.11345.17.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1103558483.11345.17.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-hotplug-devel@lists.sourceforge.net" <linux-hotplug-devel@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello,

here goes multipath-tools-0.4.2

The focuses of this release are :
1) bugfixing and stabilization after the DM synthax change
2) code factorizing between the configurator and the daemon

Full ChangeLog for the release :

        * [libmultipath] add symmetrix controler family to the
          hwtable. Edward Goggin, EMC
        * [libmultipath] factorize core structs (path, ...)
          and defaults (pidfile, configfile, ...). Convert
          callers.
        * [multipath] fix dmparser to properly fetch non-default
          hwhandler. Edward Goggin, EMC
        * [multipath] fix devt2devname matching 8:1 with 8:10
          for example. Edward Goggin, EMC
        * [multipath] switch_pg upon devmap create or reload
          Noticed by Ake.
        * [libmultipath] move find_hw() the library. Convert
          users. Now multipathd understand '*' as a product
          string
        * [multipath] dissaemble_map() fix to avoid to
          interpret 'D' as a disable PG (not 'F'). Edward
          Goggin, EMC
        * [multipath] find_path() fix to avoid matching 8:1
          with 8:10 for example. Edward Goggin, EMC
        * [libmultipath] move some sysfs fetching routines
          to library, under sysfs_devinfo.[ch]. Convert
          callers.
        * [multipath] fix -v0 : avoids the daemon waiting
          for the initial multipath run to complete, which
          will never happen because of a flooded pipe
        * [multipathd] add scsi_id to default binvec
        * [libmultipath] move hwtable related logic to the
          library. Convert multipath and multipathd
        * [multipath] move first blacklist call down after
          setup_default_blist()
        * [libmultipath] move basename() to the lib. Convert
          multipath and multipathd.
        * [libmultipath] move blacklist related logic to the
          library. Convert multipath and multipathd
        * [multipath] fix bug in the default hardware table
          matching logic (Lars M-B, Suse)
        * [multipath] allow "*" as scsi model string wildcard
          (Lars M-B, Suse)
        * [multipath] provide a macro to fill all hwe fields,
          use it to declare Clariion models (Lars M-B, Suse)
        * [multipath] use DEFAULT_GETUID instead of hardcoded
          *and* incorrect "/bin/scsi_id -g -s" (Lars M-B, Suse)
        * [multipath] kill superfluous suspend before table
          reload. The code was unsafe, as spotted by Edward
          Goggin (EMC)
        * [multipath] exit early if device parameter is
          blacklisted
        * [multipath] don't check for prefix in initrd's
          multipath.dev : this is the tool responsability to
          exit early based on its blacklist.
        * [multipath] don't signal the daemon in initrd
          (Guido Guenther, Debian tracker)
        * [multipath] better fail to run kpartx in initrd
          than crashing the whole system. So don't sleep
          waiting for udev to create the DM node. Maybe udev
          has made progress I this regard ... (noticed by
          Paul Wagland, Debian tracker)
        * [multipath] don't reinstate when listing, ie list
          implies dry_run
        * [checkers] fix the emc checker (Hergen Lange)
        * [multipath] node_name fetching shouldn't exit on
          error. FC SAN are not the only multipathed context
          (noticed by Ramesh Caushik)

As usual, doc and download at :
http://christophe.varoqui.free.fr/

regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
