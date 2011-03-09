From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 0/2] hpsa: add resettable sysfs host attribute
Date: Wed, 09 Mar 2011 16:59:56 -0600
Message-ID: <20110309225822.26877.94051.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com
List-Id: linux-scsi@vger.kernel.org

At Redhat's request, this adds a sysfs host attribute to indicate whether
the reset_devices kernel parameter can be honored by the device.  This enables 
kexec tools to warn the user if they attempt to designate a non-resettable device
as the dump device.  If the device is not resettable, kdump won't work.

---

Stephen M. Cameron (2):
      hpsa: move device attributes to avoid forward declarations
      hpsa: export resettable host attribute


 Documentation/scsi/hpsa.txt |   12 ++
 drivers/scsi/hpsa.c         |  276 ++++++++++++++++++++++++-------------------
 2 files changed, 164 insertions(+), 124 deletions(-)

--
-- steve
