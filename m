From: Patrick Mansfield <patmans@us.ibm.com>
Subject: scsi_id release 0.3
Date: Fri, 16 Jan 2004 11:45:17 -0800
Sender: linux-hotplug-devel-admin@lists.sourceforge.net
Message-ID: <20040116114517.A8526@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-hotplug-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
Errors-To: linux-hotplug-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-hotplug-devel@lists.sourceforge.net>
List-Help: <mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-hotplug-devel>,
	<mailto:linux-hotplug-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-hotplug-devel>
To: linux-scsi@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

Hi -

Version 0.3 of scsi_id is available at:

http://www-124.ibm.com/storageio/scsi_id/scsi_id-0.3.tar.gz

scsi_id is a program to generate a SCSI unique identifier for a given SCSI
device.

It is primarily for use with udev callout config entries. It can also be
used for automatic multi-path configuration or device mapper configuration.

Version 0.3 requires:

- Linux kernel 2.6
- libsysfs 0.4.0

Major changes since the last release:

	- Changes to work with libsysfs 0.4.0

All changes:

	- fix "prefix" usage for path to scsi_id.config

	- install the sample scsi_id.config file.

	- Use DESTDIR in all install/uninstall rules, per problem reported
	  by Svetoslav Slavtchev.

	- Fix to work with current sysfs 0.4, based on patch from Dan
	  Stekloff, but uses sysfs_read_attribute_value instead of
	  sysfs_get_value_from_attributes.

	- SYSFS_BUS_DIR was replaced with SYSFS_BUS_NAME.

	- Must now use sysfs_open_class_device_path instead of the
	  previous sysfs_open_class_device.

	- patch from Olaf Hering <olh@suse.de> remove DEBUG and
	  add --fno-builtin


-------------------------------------------------------
The SF.Net email is sponsored by EclipseCon 2004
Premiere Conference on Open Tools Development and Integration
See the breadth of Eclipse activity. February 3-5 in Anaheim, CA.
http://www.eclipsecon.org/osdn
