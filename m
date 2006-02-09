From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [patch 08/15] libata: Add ability to prevent PRD from being allocated
Date: Thu, 09 Feb 2006 02:20:48 -0500
Message-ID: <43EAED50.6060707@pobox.com>
References: <200602061542.k16FgXXX015889@d03av03.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200602061542.k16FgXXX015889@d03av03.boulder.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: brking@us.ibm.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

brking@us.ibm.com wrote:
> For some HBAs, particularly SAS HBAs, there is no reason to
> allocate a PRD buffer, since it is not used. Add a flag
> to prevent its allocation.
> 
> Signed-off-by: Brian King <brking@us.ibm.com>

ACK.  This is nice to have regardless of SAS, and perhaps should be 
bumped up in the patch order.


