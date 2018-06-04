From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2 0/2] 4.14 long term stable ZBC fixes
Date: Mon,  4 Jun 2018 17:04:11 +0900
Message-ID: <20180604080413.30747-1-damien.lemoal@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Patch 4b433924b275 ("scsi: sd_zbc: Fix potential memory leak") was added in
4.16 and 4.15 stable but did not make it to long term stable 4.14 (as far as I
can tell).

Patch ccce20fc7968 ("scsi: sd_zbc: Avoid that resetting a zone fails
sporadically") is included in 4.16 but does not apply to 4.15 stable nor to
4.14 long term stable and requires extensive modifications.

This small series provides a backport of both patches against 4.14. Please
consider these patches for inclusion in this long term stable kernel.

Bart Van Assche (1):
  scsi: sd_zbc: Avoid that resetting a zone fails sporadically

Damien Le Moal (1):
  scsi: sd_zbc: Fix potential memory leak

 drivers/scsi/sd_zbc.c | 128 +++++++++++++++++++++++++-----------------
 1 file changed, 76 insertions(+), 52 deletions(-)

Changes from v1:
* Fixed upstream commit reference in the first patch commit message

-- 
2.17.0
