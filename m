From: Andrew Vasquez <praka@san.rr.com>
Subject: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b2).
Date: Mon, 19 May 2003 15:57:28 -0700
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030519225728.GA17279@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

All,

A new version of the 8.x series driver for Linux 2.5.x kernels has
been uploaded to SourceForge:

	http://sourceforge.net/projects/linux-qla2xxx/

In addition to the standard kernel-tree and external build tar-balls,
a patch file is provided to update v8.00.00b1 sources to v8.00.00b2.

Changes include:

 *	- Add support for new 'Hotplug initialization' model. 
 *	- Simplify host template by removing unused callbacks.
 *	- Use scsicam facilities to determine geometry.
 *	- Fix compilation issues for non-ISP23xx builds:
 *	  - Correct register references in qla_dbg.c.
 *	  - Correct Makefile build process.
 *	- Simplify dma_addr_t handling during command queuing given
 *	  new block-layer defined restrictions:
 *	  - Physical addresses not spanning 4GB boundaries.
 *	- Resync with 2.5.69-bk8.
 
Regards,
Andrew Vasquez
QLogic Corporation
