From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC v2 05/21] tcm: Add ConfigFS subsystem backstore
 infrastructure
Date: Wed, 6 Oct 2010 09:17:12 +0900
Message-ID: <20101006091219Q.fujita.tomonori@lab.ntt.co.jp>
References: <1285195750-11516-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46918 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757955Ab0JFARm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Oct 2010 20:17:42 -0400
In-Reply-To: <1285195750-11516-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu, hch@lst.de, hare@suse.de, James.Bottomley@suse.de, axboe@kernel.dk, bharrosh@panasas.com

On Wed, 22 Sep 2010 15:49:10 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds the TCM/ConfigFS core HBA and device backstore infrastructre
> objects in /sys/kernel/config/target/core.  It includes wrappers to logic for
> Persistent Reservations and ALUA, and supports Linux/SCSI, Linux/BLOCK, and Linux/FILEIO
> backstores using TCM subsystem plugin API.
> 
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_configfs.c | 3334 +++++++++++++++++++++++++++++++++
>  include/target/target_core_configfs.h |   57 +
>  2 files changed, 3391 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/target/target_core_configfs.c
>  create mode 100644 include/target/target_core_configfs.h

Can a driver create a directory/file under configfs?

ibmvscsi target driver gets the list of targets to set up from
hardware (see how drivers/scsi/ibmvscsi/ibmvstgt.c use
vio_register_driver). The driver needs to tell an user about it so
that he can set up luns, etc via configfs.
