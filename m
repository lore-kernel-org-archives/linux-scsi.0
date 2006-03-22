From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 07/15] libata: Remove dependence on host_set->dev for
 SAS
Date: Tue, 21 Mar 2006 21:05:06 -0500
Message-ID: <4420B0D2.2060606@pobox.com>
References: <200603172304.k2HN4gNg015028@d03av03.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200603172304.k2HN4gNg015028@d03av03.boulder.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Brian King wrote:
> Remove some of the dependence on the host_set struct
> in preparation for supporting SAS HBAs. Adds a struct device
> pointer to the ata_port struct.
> 
> Signed-off-by: Brian King <brking@us.ibm.com>

Given previous discussion, ACK.


