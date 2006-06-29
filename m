From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 4/4] libata: Check per device max cdb length for SAS -
 drop
Date: Wed, 28 Jun 2006 23:53:21 -0500
Message-ID: <44A35CC1.1030407@us.ibm.com>
References: <200606281330.k5SDUrOv021506@d03av04.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200606281330.k5SDUrOv021506@d03av04.boulder.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Brian King wrote:
> Since libata does not own any scsi_host struct for
> SAS attached SATA devices, libata cannot rely on scsi
> core checking the max_cmd_len. This patch adds additional
> checking into the SAS queuecommand path to prevent
> too large of a cdb from being issued to an ATA or ATAPI device.

I'd like to drop this patch from the series. This patch would end up
preventing ATA passthrough from working to ATA/ATAPI devices that
support < 16 byte CDBs.


Brian
