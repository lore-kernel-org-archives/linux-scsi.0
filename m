From: Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 0/2] scsi: hyper-v storvsc changes by Ubuntu
Date: Fri, 16 May 2014 16:39:06 +0100
Message-ID: <1400254748-21573-1-git-send-email-abbotti@mev.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: linux-scsi@vger.kernel.org, devel@linuxdriverproject.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Ian Abbott <abbotti@mev.co.uk>, Andy Whitcroft <apw@canonical.com>
List-Id: linux-scsi@vger.kernel.org

These changes to the Microsoft Hyper-V storage driver in Ubuntu Saucy's
3.13 kernel look useful for the mainline kernel, especially as they
enable 'TRIM' support.

Andy Whitcroft (2):
  scsi: hyper-v storvsc switch up to SPC-3
  scsi: hyper-v storvsc -- host takes MAINTENANCE_IN commands badly --
    elide them

 drivers/scsi/storvsc_drv.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

-- 
1.9.2
