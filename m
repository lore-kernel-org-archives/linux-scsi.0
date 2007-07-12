From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: ipr using libata old-EH
Date: Thu, 12 Jul 2007 17:17:17 -0500
Message-ID: <4696A86D.1000300@linux.vnet.ibm.com>
References: <46968793.8070803@garzik.org>
Reply-To: brking@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <46968793.8070803@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> I just noticed that ipr is still using the old reset and error handling 
> methods.  Once libata-dev.git (#mv-eh, #new-eh) work is merged, ipr is 
> the last driver that uses old error handling methods.  Please look into 
> upgrading the driver to ->error_handler(), ->freeze(), ->thaw().

I'll look into this.

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center
