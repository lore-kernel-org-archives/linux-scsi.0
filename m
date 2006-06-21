From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] Print SCSI Inquiry data more compactly
Date: Wed, 21 Jun 2006 10:50:55 -0400
Message-ID: <44995CCF.3050200@torque.net>
References: <20060620222756.GO1630@parisc-linux.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:14523 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932112AbWFUOwA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 10:52:00 -0400
In-Reply-To: <20060620222756.GO1630@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> print_inquiry is rather verbose, both in implementation and in output.
> This patch reduces the output from two lines to one and reduces the
> implementation to a single printk.
> 
> Sample output:
>   Vendor: HP 18.2G  Model: ATLAS10K3_18_SCA  Rev: HP05
>   Type:   Direct-Access                      ANSI SCSI revision: 02
> 
> becomes:
> 
> scsi 2:0:1:0: Device: HP 18.2G ATLAS10K3_18_SCA HP05 ANSI ver: 02               

The peripheral device type is useful information, especially
when it is other than "Direct Access".

Doug Gilbert
