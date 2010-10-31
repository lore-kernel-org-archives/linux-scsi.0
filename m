From: Joe Perches <joe@perches.com>
Subject: [PATCH 0/4] Fix k.alloc switched arguments
Date: Sun, 31 Oct 2010 15:33:52 -0700
Message-ID: <cover.1288555098.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/devel>,
	<mailto:devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/devel>
List-Post: <mailto:devel@linuxdriverproject.org>
List-Help: <mailto:devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/devel>,
	<mailto:devel-request@linuxdriverproject.org?subject=subscribe>
Sender: devel-bounces@linuxdriverproject.org
Errors-To: devel-bounces@linuxdriverproject.org
To: linux-kernel@vger.kernel.org
Cc: devel@driverdev.osuosl.org, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>, linux-scsi@vger.kernel.org, David Airlie <airlied@linux.ie>, Greg Kroah-Hartman <gregkh@suse.de>, dri-devel@lists.freedesktop.org, "James E.J. Bottomley" <James.Bottomley@suse.de>, Andy Whitcroft <apw@canonical.com>
List-Id: linux-scsi@vger.kernel.org

Joe Perches (4):
  drivers/gpu/drm/vmwgfx: Fix k.alloc switched arguments
  drivers/scsi/pmcraid.c: Fix k.alloc switched arguments
  drivers/staging/udlfb/udlfb.c: Fix k.alloc switched arguments
  scripts/checkpatch.pl: Add check for k.alloc GFP as first argument

 drivers/gpu/drm/vmwgfx/vmwgfx_ldu.c     |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c |    2 +-
 drivers/scsi/pmcraid.c                  |    4 ++--
 drivers/staging/udlfb/udlfb.c           |    2 +-
 scripts/checkpatch.pl                   |    5 +++++
 5 files changed, 10 insertions(+), 5 deletions(-)

-- 
1.7.3.1.g432b3.dirty
