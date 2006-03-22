From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 06/15] libata: Stop using host->max_cmd_len
Date: Tue, 21 Mar 2006 21:03:07 -0500
Message-ID: <4420B05B.6090702@pobox.com>
References: <200603172304.k2HN4YEF019986@d03av01.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200603172304.k2HN4YEF019986@d03av01.boulder.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Brian King wrote:
> In preparation for SAS attached SATA devices, quit using
> the max_cmd_len in the scsi_host struct.
> 
> Signed-off-by: Brian King <brking@us.ibm.com>

I see this as a bit of a hack.  In general, its best to inform upper 
layers of known limits as soon as possible.  For the non-SAS case, for 
that point of view, this patch is a regression.

	Jeff


