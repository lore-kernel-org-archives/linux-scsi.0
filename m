From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 13/15] scsi: make device_type const
Date: Fri, 25 Aug 2017 17:30:22 -0400
Message-ID: <yq11snz72tt.fsf@oracle.com>
References: <1503130946-2854-1-git-send-email-bhumirks@gmail.com>
 <1503130946-2854-14-git-send-email-bhumirks@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1503130946-2854-14-git-send-email-bhumirks@gmail.com> (Bhumika
 Goyal's message of "Sat, 19 Aug 2017 13:52:24 +0530")
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Bhumika Goyal <bhumirks@gmail.com>
Cc: heikki.krogerus@linux.intel.com, airlied@linux.ie, linux-pci@vger.kernel.org, heiko.carstens@de.ibm.com, dri-devel@lists.freedesktop.org, bjorn.andersson@linaro.org, linux-tegra@vger.kernel.org, thierry.reding@gmail.com, linux-mtd@lists.infradead.org, daniel.vetter@intel.com, kishon@ti.com, freude@de.ibm.com, boris.brezillon@free-electrons.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, richard@nod.at, jonathanh@nvidia.com, marek.vasut@gmail.com, fcoe-devel@open-fcoe.org, dvhart@infradead.org, tomas.winkler@intel.com, open-iscsi@googlegroups.com, linux-media@vger.kernel.org, ohad@wizery.com, devel@driverdev.osuosl.org, linux-s390@vger.kernel.org, linux-remoteproc@vger.kernel.org, johan@kernel.org, jani.nikula@linux.intel.com, julia.lawall@lip6.fr, seanpaul@chromium.org, bhelgaas@google.com, mchehab@kernel.org, linux-edac@vger.kernel.org, cleech@redhat.com, jth@
List-Id: linux-scsi@vger.kernel.org


Bhumika,

> Make these const as they are only stored in the type field of a device
> structure, which is const.

Applied to 4.14/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
