From: Joe Perches <joe@perches.com>
Subject: RE: [PATCH] [21/2many] MAINTAINERS - AACRAID SCSI RAID DRIVER
Date: Mon, 13 Aug 2007 10:20:08 -0700
Message-ID: <1187025608.10249.141.camel@localhost>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01D12AA7@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:3224 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032462AbXHMRUW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Aug 2007 13:20:22 -0400
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01D12AA7@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org

On Mon, 2007-08-13 at 10:16 -0400, Salyzyn, Mark wrote:
> Second thoughts ... Add the documentation file as well.
> +F:	Documentation/scsi/aacraid.txt

AACRAID SCSI RAID DRIVER
P:	Adaptec OEM Raid Solutions
M:	aacraid@adaptec.com
L:	linux-scsi@vger.kernel.org
W:	http://www.adaptec.com/
S:	Supported
F:	Documentation/scsi/aacraid.txt
F:	drivers/scsi/aacraid/

Maybe all 3 entries should be collapsed into

ADAPTEC SCSI RAID (AACRAID, DPT_I2O, IPS)?
P:	Adaptec OEM Raid Solutions
M:	aacraid@adaptec.com
L:	linux-scsi@vger.kernel.org
W:	http://www.adaptec.com/
S:	Supported
F:	Documentation/scsi/aacraid.txt
F:	drivers/scsi/aacraid/


